defmodule MyHive.Repo.Migrations.AddFirstNameAndLastNameToSharedDirectory do
  use Ecto.Migration

  def change do
    alter table(:shareable_directories) do
      add :first_name, :string
      add :last_name, :string
    end
  end
end
