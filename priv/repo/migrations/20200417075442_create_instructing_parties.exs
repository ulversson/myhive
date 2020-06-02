defmodule MyHive.Repo.Migrations.CreateInstructingParties do
  use Ecto.Migration

  def change do
    create table(:instructing_parties) do
      add :name, :binary
      add :address_id, :integer
      add :contact_name, :binary
      timestamps()
    end

  end
end
