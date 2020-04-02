defmodule MyHive.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.Encryption
  alias MyHive.Avatarly.Generator
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
    field :avatar_svg, :string
    field(:roles, {:array, :string}, default: ["expert"])
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
    |> generate_avatar
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

  defp generate_avatar(changeset) do 
    first_name = get_change(changeset, :first_name)
    last_name = get_change(changeset, :last_name)
    if (first_name && last_name) do 
      full_name = first_name <> " " <> last_name
      avatar = List.to_string(Generator.call(full_name, [size: 32, color: "random"]))
      put_change changeset, :avatar_svg, avatar
    else
      changeset  
    end  
  end  
end
