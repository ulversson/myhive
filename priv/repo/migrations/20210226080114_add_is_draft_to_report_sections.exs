defmodule MyHive.Repo.Migrations.AddIsDraftToReportSections do
  use Ecto.Migration

  def change do
    alter table(:reports_user_medico_legal_cases) do
      add :unique_key, :string
    end
    Ecto.Adapters.SQL.query!(
      MyHive.Repo, "DROP TABLE reports_draft_documents"
    )
  end
end
