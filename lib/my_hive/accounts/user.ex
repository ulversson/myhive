defmodule MyHive.Accounts.User do
  use GuardianTrackable.Schema
  use Ecto.Schema

  import Ecto.Changeset

  alias MyHive.Regex.RegularExpressions
  alias MyHive.Accounts.Encryption
  alias MyHive.Avatarly.UserAvatars
  alias MyHive.Saas

  @valid_roles ["Admin": "admin", "Super Admin": "super_admin", "Expert": "expert"]

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :first_name, :string
    field :is_active, :boolean, default: false
    field :last_name, :string
    field :has_2fa, :boolean, default: true
    field :verified, :boolean, default: false
    field :force_sign_out, :boolean, default: false
    field :phone_number, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :avatar_32, :string
    field :avatar_128, :string
    field :avatar_256, :string
    field :roles, {:array, :string}, default: ["expert"]
    many_to_many :saas_accounts, Saas.Account, join_through: Saas.AccountUser
    guardian_trackable()
    timestamps()
  end

  def valid_roles do
    @valid_roles
  end
  @doc false
  def initial_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :phone_number, :password, :verified, :roles, :force_sign_out, :is_active])
    |> validate_required([:email, :first_name, :last_name, :phone_number, :is_active])
    |> validate_length(:first_name, min: 3)
    |> validate_format(:email, RegularExpressions.email_regex, message: "must be a valid email address")
    |> validate_length(:last_name, min: 3)
    |> unique_constraint(:email)
    |> downcase_email
    |> generate_avatar(32)
    |> generate_avatar(128)
    |> generate_avatar(256)
  end

  def changeset(user, attrs) do
    user
    |> initial_changeset(attrs)
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
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

  defp generate_avatar(changeset, size) do
    UserAvatars.call(size, changeset)
  end

end
