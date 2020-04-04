defmodule MyHive.Accounts.User do
  use GuardianTrackable.Schema
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.Encryption
  alias MyHive.Avatarly.UserAvatars
  require IEx

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :first_name, :string
    field :is_active, :boolean, default: false
    field :last_name, :string
    field(:has_2fa, :boolean, default: true) 
    field :phone_number, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :avatar_32, :string
    field :avatar_128, :string
    field :avatar_256, :string
    field(:roles, {:array, :string}, default: ["expert"])
    guardian_trackable()
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :phone_number, :password, :is_active, :roles])
    |> validate_required([:email, :first_name, :last_name, :phone_number, :is_active])
    #|> validate_inclusion(:roles, ~w(expert admin super_admin))
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> validate_length(:first_name, min: 3)
    |> validate_length(:last_name, min: 3)
    |> unique_constraint(:email)
    |> downcase_email
    |> encrypt_password
    |> generate_avatar(32)
    |> generate_avatar(128)
    |> generate_avatar(256)
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
