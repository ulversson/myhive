defmodule MyHive.CaseManagement.PatientConsultationFolder do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.ContactBook.CasePerson
  alias MyHive.CaseManagement.PatientConsultation
  schema "patient_consultations_folders" do
    field :folder_id, Ecto.UUID
    belongs_to :consultation, PatientConsultation, foreign_key: :patient_consultation_id
    belongs_to :patient, CasePerson,  where: [person_type: "Patient"], on_replace: :update
    timestamps()
  end

  @doc false
  def changeset(patient_consultation_folder, attrs) do
    patient_consultation_folder
    |> cast(attrs, [:patient_id, :folder_id, :patient_consultation_id])
    |> validate_required([:patient_id, :folder_id, :patient_consultation_id])
  end
end
