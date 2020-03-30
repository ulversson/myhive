defmodule MyHive.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.Encryption

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :first_name, :string
    field :is_active, :boolean, default: false
    field :last_name, :string
    field :phone_number, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :phone_number, :password, :is_active])
    |> validate_required([:email, :first_name, :last_name, :phone_number, :is_active])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> validate_length(:first_name, min: 3)
    |> validate_length(:last_name, min: 3)
    |> unique_constraint(:email)
    |> downcase_email
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)
    if password do
      encrypted_password = Encryption.hash_password(password)
      put_change(changeset, :encrypted_password, encrypted_password)
    else
      changeset
    end
  end

  defp downcase_email(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end
end
