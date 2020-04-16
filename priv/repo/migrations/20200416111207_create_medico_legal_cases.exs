defmodule MyHive.Repo.Migrations.CreateMedicoLegalCases do
  use Ecto.Migration

  def change do
    create table(:medico_legal_cases) do
      add :user_id, :integer
      add :folder_id, :integer
      add :status, :string
      add :due_date, :date
      add :case_summary, :text
      add :note, :text
      add :claimant_defendant, :boolean, default: false, null: false
      add :notifications_disabled, :boolean, default: false, null: false
      add :patient_deceased, :boolean, default: false, null: false

      timestamps()
    end

  end
end
