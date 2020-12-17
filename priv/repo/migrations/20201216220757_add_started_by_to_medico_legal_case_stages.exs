defmodule MyHive.Repo.Migrations.AddStartedByToMedicoLegalCaseStages do
  use Ecto.Migration

  def change do
    alter table(:medico_legal_case_statuses) do
      add :started_by, :integer
    end
  end
end
