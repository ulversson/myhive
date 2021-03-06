defmodule MyHive.Accounts do

  import Ecto.Query, warn: false
  alias MyHive.{
    Repo, FileManager
  }
  alias MyHive.Accounts.{
    User, QuickLink, Settings, MobileDevice
  }
  alias MyHive.FileManager.DocumentProvider
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def token_sign_in(email, password) do
    case email_password_auth(email, password) do
      {:ok, user} ->
        MyHive.Guardian.encode_and_sign(user)
      _ ->
        {:error, :unauthorized}
    end
  end

  defp email_password_auth(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- get_by_email(email),
    do: verify_password(password, user)
  end

  def get_by_email(email) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        dummy_checkpw()
        {:error, "Login error."}
      user ->
        {:ok, user}
    end
  end


  def by_first_and_last_name(first_name, last_name) do
    sfirst_name="%#{first_name}%"
    slast_name="%#{last_name}%"
    query = from p in User,
      where: like(p.first_name, ^sfirst_name) and
        like(p.last_name, ^slast_name),
      limit: 1
    Repo.one(query)
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    if checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end

  def mark_as_verified(user) do
    user
    |> Ecto.Changeset.change(%{verified: true})
    |> Repo.update()
  end

  def mark_for_sign_out(user) do
    user
    |> Ecto.Changeset.change(%{force_sign_out: true})
    |> Repo.update()
  end

  def disable_mark_for_sign_out(user) do
    user
    |> Ecto.Changeset.change(%{force_sign_out: false})
    |> Repo.update()
  end

  def update_password(user, password) do
    user |> User.changeset(%{
      password: password,
      password_confirmation: password
    }) |> Repo.update()
  end
  def list_users do
    Repo.all(User)
  end

  def all_by_name(exclude_id \\ nil) do
    query = from(u in User,
      order_by: [u.first_name, u.last_name])
    if not is_nil(exclude_id) do
      where(query, [u], u.id != ^exclude_id)
    end
    query |> Repo.all
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.initial_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.initial_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def change_user(%User{} = user, params) do
    User.changeset(user, params)
  end

  def random_user() do
    list_users() |> Enum.take_random(1) |> List.first()
  end

  def query_by_name(name, exclude_id \\ nil) do
    search_term = "%#{name}%"
    query = from(u in User,
      where: ilike(u.first_name, ^search_term) or
      ilike(u.last_name, ^search_term),
      order_by: [u.last_name, u.first_name],
      select: %{id: u.id, first_name: u.first_name, last_name: u.last_name})
    if not is_nil(exclude_id) do
      where(query, [u], u.id != ^exclude_id)
    end
    query
  end

  def get_users_by_ids(ids) do
    users_query =
      from(
        u in User,
        preload: [:user_medico_legal_cases,
          :medico_legal_cases, :saas_accounts],
        where: u.id in ^ids,
        select: u
      )

    Repo.all(users_query)
  end

  def get_accounts_ids(user) do
    user = user |> Repo.preload(:saas_accounts)
    Enum.map(user.saas_accounts, fn x ->  x.id end)
  end

  def is_admin_or_super_admin?(user) do
    is_super_admin?(user) || Enum.member?(user.roles, "admin")
  end

  def is_super_admin?(user) do
    Enum.member?(user.roles, "super_admin")
  end

  def is_archiver?(user) do
    Enum.member?(user.roles, "archiver")
  end

  def document_provider(user) do
    Repo.get_by(DocumentProvider, id: user.settings.document_provider_id)
  end

  def quick_links_for_user(user_id) do
    query = from l in QuickLink,
      where: l.user_id == ^user_id,order_by: [l.name]
    query |> Repo.all
  end

  def create_quick_link(changeset) do
    %QuickLink{}
      |> QuickLink.changeset(changeset)
      |> Repo.insert()
  end

  def get_quick_link!(id) do
    Repo.get_by(QuickLink, id: id)
  end

  def delete_link(%QuickLink{} = link) do
    Repo.delete(link)
  end

  def add_default_settings(user) do
    user
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_embed(:settings, Settings.default())
    |> Repo.update()
  end

  def default_provider() do
    DocumentProvider |> first(:inserted_at) |> Repo.one()
  end

  def add_to_trackable_folders(user) do
    Enum.each(FileManager.trackables(), fn folder ->
      FileManager.share_folder(folder.id, folder.user_id, user.id)
    end)
  end

  def unshare_all_folders(user) do
    Enum.each(FileManager.trackables(), fn folder ->
      FileManager.unshare_folder(folder.id, folder.user_id, [user.id])
    end)
  end

  def set_reset_token(user) do
    user
      |> Ecto.Changeset.change(%{reset_email_token: Ecto.UUID.generate})
      |> Repo.update()
  end

  def find_by_reset_token(token) do
    Repo.get_by(User, reset_email_token: token)
  end

  def delete_devices(user_id, platform, device_type, except_id) do
    query = from d in MobileDevice,
      where: d.user_id == ^user_id and
      d.os == ^platform and
      d.device_type == ^device_type and
      d.id != ^except_id
    Repo.delete_all(query)
  end

  def create_mobile_device(params) do
    %MobileDevice{}
    |> MobileDevice.changeset(params)
    |> Repo.insert()
  end

  def find_by_device_id(id) do
    Repo.get_by(MobileDevice, id: id)
  end

  def first_or_create_by(user_id, udid, params) do
    query = from d in MobileDevice,
      where: d.user_id == ^user_id and
      d.udid == ^udid
    case Repo.one(query) do
      nil ->
        {:ok, device} =
          create_mobile_device(Map.merge(%{
            user_id: user_id,
            udid: udid,
          }, params))
      device

      device -> device
    end
  end

  def update_notification_token(device, token) do
    device
      |> Ecto.Changeset.change(%{token: token})
      |> Repo.update()
  end


end
