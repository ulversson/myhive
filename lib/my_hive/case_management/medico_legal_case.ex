defmodule MyHive.CaseManagement.MedicoLegalCase do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.{ContactBook, CaseManagement, Accounts, FileManager, Saas}

  schema "medico_legal_cases" do
    field :case_summary, :string
    field :instructed_by, :string
    field :due_date, :date
    field :note, :string
    field :notifications_disabled, :boolean, default: false
    field :status, :string, default: "pending"
    field :user_ids, :string, virtual: true
    has_many :case_people, ContactBook.CasePerson
    has_many :user_medico_legal_cases, CaseManagement.UserMedicoLegalCase
    belongs_to :user, Accounts.User
    belongs_to :folder, FileManager.Folder
    belongs_to :instructing_party, CaseManagement.InstructingParty
    belongs_to :patient, ContactBook.CasePerson,  where: [person_type: "Patient"]
    belongs_to :claimant, ContactBook.CasePerson,  where: [person_type: "Claimant"]
    belongs_to :account, Saas.Account
    timestamps()
  end

  @doc false
  def changeset(medico_legal_case, attrs \\ %{}) do
    medico_legal_case
    |> cast(attrs, [:user_id, :folder_id, :status, :due_date, :account_id,
      :case_summary, :note, :instructed_by, :patient_id, :notifications_disabled, :user_ids])
    |> validate_required([:user_id, :status, :user_ids])
  end

  def changeset_assoc(medico_legal_case, attrs \\ %{}) do
    medico_legal_case
    |> changeset(attrs)
    |> cast_assoc(:instructing_party, required: false)
    |> optionally_require_patient
    |> cast_assoc(:claimant, required: false)
  end


  defp optionally_require_patient(changeset) do
    key_to_check = get_change(changeset, :patient_id)
    if key_to_check do
      changeset
    else
      cast_assoc(changeset, :patient, required: true)
    end
  end
end
