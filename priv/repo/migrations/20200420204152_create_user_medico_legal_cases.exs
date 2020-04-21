defmodule MyHive.Repo.Migrations.CreateUserMedicoLegalCases do
  use Ecto.Migration

  def change do
    create table(:user_medico_legal_cases) do
      add :user_id, :integer
      add :medico_legal_case_id, :integer
      add :patient_id, :integer

      timestamps()
    end
    create index(:user_medico_legal_cases, [:user_id])
    create index(:user_medico_legal_cases, [:medico_legal_case_id])
  end
end
