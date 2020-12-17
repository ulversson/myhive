defmodule MyHive.Repo.Migrations.CreateMedicoLegalCaseStatuses do
  use Ecto.Migration

  def change do
    create table(:medico_legal_case_statuses) do
      add :medico_legal_case_id, :integer
      add :medico_legal_case_progress_state_id, :integer
      add :started_at, :naive_datetime
      add :completed_at, :naive_datetime
      add :completed_by, :integer
      add :order, :integer

      timestamps()
    end

  end
end
