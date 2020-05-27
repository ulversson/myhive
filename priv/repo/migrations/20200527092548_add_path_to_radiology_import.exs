defmodule MyHive.Repo.Migrations.AddPathToRadiologyImport do
  use Ecto.Migration

  def change do
    alter table(:radiology_imports) do
      add :path, :string
    end
  end
end
