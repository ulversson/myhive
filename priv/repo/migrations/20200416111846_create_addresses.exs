defmodule MyHive.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :address_line1, :string
      add :address_line2, :string
      add :address_line3, :string
      add :addressable_id, :integer
      add :addressable_type, :string
      add :phone_number, :string
      add :email, :string
      add :name, :string

      timestamps()
    end

  end
end
