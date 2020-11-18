defmodule MyHive.Repo.Migrations.CreateCaseManagementPatientConsultations do
  use Ecto.Migration

  def change do
    create table(:case_management_patient_consultations) do
      add :patient_id, :integer
      add :medico_legal_case_id, :integer
      add :weight, :decimal
      add :height, :decimal
      add :bmi, :decimal
      add :blood_pressure, :string
      add :temperature, :decimal
      add :consultation_date, :naive_datetime
      add :covid_consent, :boolean, default: false
      add :user_id, :integer
      add :note, :text
      timestamps()
    end

  end
end
