defmodule MyHive.Repo.Migrations.CreateUserReportsGlossaryOfTerms do
  use Ecto.Migration

  def change do
    create table(:user_reports_glossary_of_terms) do
      add :user_medico_legal_case_report_id, :integer
      add :glossary_of_term_id, :integer
      add :content, :text
      timestamps()
    end

  end
end
