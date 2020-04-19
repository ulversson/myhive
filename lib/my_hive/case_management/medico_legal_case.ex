defmodule MyHive.CaseManagement.MedicoLegalCase do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.{ContactBook, CaseManagement, Accounts}
  require IEx

  schema "medico_legal_cases" do
    field :case_summary, :string
    field :instructed_by, :string
    field :due_date, :date
    field :folder_id, :integer
    field :note, :string
    field :notifications_disabled, :boolean, default: false
    field :status, :string, default: "pending"
    field :user_ids, :string, virtual: true
    belongs_to :user, Accounts.User
    belongs_to :instructing_party, CaseManagement.InstructingParty
    has_many :case_people, ContactBook.CasePerson
    has_one :patient,ContactBook.CasePerson,  where: [person_type: "Patient"]
    has_one :claimant, ContactBook.CasePerson,  where: [person_type: "Claimant"]
    timestamps()
  end

  @doc false
  def changeset(medico_legal_case, attrs \\ %{}) do
    medico_legal_case
    |> cast(attrs, [:user_id, :folder_id, :status, :due_date, :case_summary, :note, :instructed_by, :notifications_disabled, :user_ids])
    |> validate_required([:user_id, :folder_id, :status, :user_ids])
  end

  def changeset_assoc(medico_legal_case, attrs \\ %{}) do
    medico_legal_case
    |> changeset(attrs)
    |> cast_assoc(:instructing_party, required: false)
    |> cast_assoc(:patient, required: true)
    |> cast_assoc(:claimant, required: false)
    |> validate_optional(:instructing_party)
  end

  def validate_optional(changeset, key) do
    key_to_check = get_change(changeset, key)
    if key_to_check do
      changeset
    else
      changeset
    end

  end
end
