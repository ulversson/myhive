defmodule MyHive.Repo.Migrations.CreateReportsDraftDocuments do
  use Ecto.Migration

  def change do
    create table(:reports_draft_documents) do
      add :unique_key, :string
      add :document_json, :map
      add :user_id, :integer
      add :report_template_id, :integer

      timestamps()
    end

  end
end
