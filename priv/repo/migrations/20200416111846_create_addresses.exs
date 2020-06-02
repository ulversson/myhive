defmodule MyHive.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :address_line1, :binary
      add :address_line2, :binary
      add :address_line3, :binary
      add :addressable_id, :integer
      add :addressable_type, :string
      add :phone_number, :binary
      add :email, :binary
      add :name, :binary

      timestamps()
    end

  end
end
