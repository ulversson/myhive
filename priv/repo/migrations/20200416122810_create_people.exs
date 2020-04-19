defmodule MyHive.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :person_type, :string
      add :first_name, :string
      add :last_name, :string
      add :address_id, :integer
      add :date_of_birth, :date
      add :date_of_death, :date

      timestamps()
    end

  end
end
