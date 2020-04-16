defmodule MyHive.CaseManagement.MedicoLegalCase do
  use Ecto.Schema
  import Ecto.Changeset

  schema "medico_legal_cases" do
    field :case_summary, :string
    field :claimant_defendant, :boolean, default: false
    field :due_date, :date
    field :folder_id, :integer
    field :note, :string
    field :notifications_disabled, :boolean, default: false
    field :patient_deceased, :boolean, default: false
    field :status, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(medico_legal_case, attrs) do
    medico_legal_case
    |> cast(attrs, [:user_id, :folder_id, :status, :due_date, :case_summary, :note, :claimant_defendant, :notifications_disabled, :patient_deceased])
    |> validate_required([:user_id, :folder_id, :status, :due_date, :case_summary, :note, :claimant_defendant, :notifications_disabled, :patient_deceased])
  end
end
