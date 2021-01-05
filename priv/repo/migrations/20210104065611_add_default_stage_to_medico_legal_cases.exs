defmodule MyHive.Repo.Migrations.AddDefaultStageToMedicoLegalCases do
  use Ecto.Migration

  def change do
    alter table(:medico_legal_case_progress_stages) do
      add :is_default, :boolean, default: false
    end
    alter table(:medico_legal_case_statuses) do
      add :percentage, :decimal, default: 0.0
    end
  end
end
