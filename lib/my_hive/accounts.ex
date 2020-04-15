defmodule MyHive.Accounts do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Accounts.User
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

  defp get_by_email(email) when is_binary(email) do
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
    |> User.changeset(%{verified: true})
    |> Repo.update()
  end

  def mark_for_sign_out(user) do
    user
    |> User.changeset(%{force_sign_out: true})
    |> Repo.update()
  end

  def disable_mark_for_sign_out(user) do
    user
    |> User.changeset(%{force_sign_out: false})
    |> Repo.update()
  end

  def update_password(user, password) do
    user
    |> User.changeset(%{
      password: password,
      password_confirmation: password
    }) |> Repo.update()
  end
  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
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


end
