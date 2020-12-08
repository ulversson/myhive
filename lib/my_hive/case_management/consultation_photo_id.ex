defmodule MyHive.CaseManagement.ConsultationPhotoID do
  use Ecto.Schema
  import Ecto.Changeset

  schema "consultations_photo_ids" do
    field :name, :string
    belongs_to :patient_consultation, PatientConsultation
    belongs_to :file_asset, FileAsset, type: :binary_id
    timestamps()
  end

  @doc false
  def changeset(consultation_photo_id, attrs) do
    consultation_photo_id
    |> cast(attrs, [:name, :file_asset_id, :patient_consultation_id])
    |> validate_required([:name,  :file_asset_id, :patient_consultation_id])
  end
end
