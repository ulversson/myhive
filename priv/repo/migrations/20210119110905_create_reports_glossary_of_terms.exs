defmodule MyHive.Repo.Migrations.CreateReportsGlossaryOfTerms do
  use Ecto.Migration

  def change do
    create table(:reports_glossary_of_terms) do
      add :name, :string
      add :description, :text

      timestamps()
    end

  end
end
