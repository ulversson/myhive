defmodule MyHive.Repo.Migrations.CreateInstructingParties do
  use Ecto.Migration

  def change do
    create table(:instructing_parties) do
      add :name, :string
      add :address_id, :integer
      add :contact_name, :string
      timestamps()
    end

  end
end
