defmodule MyHive.Repo.Migrations.AddMlcIdToDocumentDrafts do
  use Ecto.Migration

  def change do
    alter table(:reports_draft_documents) do
      add :medico_legal_case_id, :integer
    end

  end
end
