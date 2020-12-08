defmodule MyHive.Repo.Migrations.CreatePatientConsultationsFolders do
  use Ecto.Migration

  def change do
    create table(:patient_consultations_folders) do
      add :patient_id, :integer
      add :folder_id, :uuid
      add :patient_consultation_id, :integer

      timestamps()
    end

  end
end
