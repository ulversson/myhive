defmodule MyHive.CaseManagement.MedicoLegalCase do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Encryption.EncryptedField
  alias MyHive.{
    ContactBook,
    CaseManagement,
    Accounts,
    FileManager,
    Saas
  }

  schema "medico_legal_cases" do
    field :case_summary, EncryptedField
    field :instructed_by, EncryptedField
    field :due_date, :date
    field :note, EncryptedField
    field :notifications_disabled, :boolean, default: false
    field :status, :string, default: "pending"
    field :user_ids, {:array, :string}, virtual: true
    field :started_at, :utc_datetime
    field :file_reference, :string
    field :settled_at, :utc_datetime
    field :folder_id, :binary
    has_many :user_medico_legal_cases, CaseManagement.UserMedicoLegalCase
    many_to_many :users, Accounts.User, join_through: CaseManagement.UserMedicoLegalCase
    belongs_to :user, Accounts.User
    belongs_to :instructing_party, CaseManagement.InstructingParty
    belongs_to :patient, ContactBook.CasePerson,  where: [person_type: "Patient"]
    belongs_to :claimant, ContactBook.CasePerson,  where: [person_type: "Claimant"]
    belongs_to :account, Saas.Account
    timestamps()
  end
  def changeset(medico_legal_case, attrs \\ %{}) do
    medico_legal_case
    |> cast(attrs, [:user_id, :folder_id, :status, :due_date, :account_id, :file_reference,
      :case_summary, :note, :instructed_by, :patient_id, :notifications_disabled, :user_ids])
    |> validate_required([:user_id, :status, :user_ids])
  end

  def correspondence_folders(medico_legal_case) do
    folders = medico_legal_case.folder_id
      |> FileManager.get_child_type("medico_legal_case_correspondence")
    if (length(folders) === 0) do
      {:error, :not_found}
    else
      {:ok, folders}
    end
  end

  def changeset_assoc(medico_legal_case, attrs \\ %{}) do
    medico_legal_case
      |> changeset(attrs)
      |> cast_assoc(:instructing_party, required: true)
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
