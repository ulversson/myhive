defmodule MyHive.CaseManagement.UserMedicoLegalCase do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.CaseManagement.MedicoLegalCase
  alias MyHive.ContactBook.CasePerson
  alias MyHive.Accounts.User

  schema "user_medico_legal_cases" do
    belongs_to :medico_legal_case, MedicoLegalCase
    belongs_to :patient, CasePerson, where: [person_type: "Patient"]
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(user_medico_legal_case, attrs) do
    user_medico_legal_case
    |> cast(attrs, [:user_id, :medico_legal_case_id, :patient_id])
    |> validate_required([:user_id, :medico_legal_case_id, :patient_id])
  end
end
