defmodule MyHive.CaseManagement.PatientConsultation do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.CaseManagement.{
    MedicoLegalCase,
    PatientConsultationFolder,
    ConsultationPhotoID
  }
  alias MyHive.ContactBook.CasePerson
  alias MyHive.Accounts.User
  alias MyHive.FileManager.Folder

  schema "case_management_patient_consultations" do
    belongs_to :medico_legal_case, MedicoLegalCase
    belongs_to :patient, CasePerson,  where: [person_type: "Patient"]
    belongs_to :user, User
    field :blood_pressure, :string
    field :bmi, :decimal
    field :consultation_date, :naive_datetime
    field :height, :decimal
    field :temperature, :decimal
    field :weight, :decimal
    field :note, :string
    field :covid_consent, :boolean, default: false
    has_many :patient_consultation_folders, PatientConsultationFolder, foreign_key: :patient_consultation_id
    many_to_many :folders, Folder, join_through: "patient_consultations_folders"
    has_one :consultation_photo_id, ConsultationPhotoID, foreign_key: :patient_consultation_id
    timestamps()
  end

  @doc false
  def changeset(patient_consultation, attrs) do
    patient_consultation
    |> cast(attrs, [:patient_id, :medico_legal_case_id, :covid_consent, :note,
       :weight, :height, :bmi, :blood_pressure, :temperature, :consultation_date, :covid_consent])
    |> validate_required([:patient_id, :medico_legal_case_id, :consultation_date])
  end
end
