defmodule MyHive.Accounts do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Accounts.{
    User, QuickLink
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
      select: %{id: u.id, first_name: u.first_name, last_name: u.last_name})
    if not is_nil(exclude_id) do
      where(query, [u], u.id != ^exclude_id)
    end
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

end
