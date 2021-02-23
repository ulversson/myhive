defmodule MyHive.Repo.Migrations.AddDescriptionToGlossaryOfTerms do
  use Ecto.Migration

  def change do
    alter table(:reports_glossary_of_terms) do
      add :letter, :string
      add :short_name, :string
    end
  end
end
