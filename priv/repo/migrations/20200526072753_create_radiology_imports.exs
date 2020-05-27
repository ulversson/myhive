defmodule MyHive.Repo.Migrations.CreateRadiologyImports do
  use Ecto.Migration

  def change do
    create table(:radiology_imports) do
      add :name, :string
      add :description, :text
      add :medico_legal_case_id, :integer
      add :result, :text
      add :error, :text
      timestamps()
    end

  end
end
