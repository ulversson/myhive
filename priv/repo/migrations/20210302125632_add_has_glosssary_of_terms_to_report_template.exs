defmodule MyHive.Repo.Migrations.AddHasGlosssaryOfTermsToReportTemplate do
  use Ecto.Migration

  def change do
    alter table(:report_templates) do 
      add :has_glossary_of_terms, :boolean, default: false
    end
  end
end
