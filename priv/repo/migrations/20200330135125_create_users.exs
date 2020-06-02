defmodule MyHive.Repo.Migrations.CreateUsers do
  use Ecto.Migration
  alias MyHive.Encryption.EncryptedField
  def change do
    create table(:users) do
      add :email, :string
      add :encrypted_password, :binary
      add :first_name, :string
      add :last_name, :string
      add :phone_number, :binary
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
