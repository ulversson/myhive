defmodule MyHive.Repo.Migrations.AddPatientIdToMlc do
  use Ecto.Migration

  def change do
    alter table(:medico_legal_cases) do
      add :patient_id, :integer
      add :claimant_id, :integer
    end
    alter table(:people) do
      remove :medico_legal_case_id, :integer
    end
  end
end
