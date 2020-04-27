defmodule MyHive.Repo.Migrations.AddDateFieldsToMedicoLegalCases do
  use Ecto.Migration

  def change do
    alter table(:medico_legal_cases) do
      add :started_at, :utc_datetime
      add :settled_at, :utc_datetime
    end
  end
end
