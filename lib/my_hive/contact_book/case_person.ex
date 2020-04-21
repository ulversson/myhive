defmodule MyHive.ContactBook.CasePerson do
  use Ecto.Schema
  import Ecto.Changeset
  require IEx
  schema "people" do
    field :date_of_birth, :date
    field :date_of_death, :date
    field :first_name, :string
    field :last_name, :string
    field :person_type, :string
    field :deceased, :boolean, default: false
    has_many :addresses, MyHive.ContactBook.Address, foreign_key: :addressable_id
    belongs_to :medico_legal_case, MyHive.CaseManagement.MedicoLegalCase
    timestamps()
  end

  @doc false
  def changeset(case_person, attrs) do
    case_person
    |> cast(attrs, [:person_type, :first_name, :last_name, :date_of_birth, :date_of_death])
    |> cast_assoc(:addresses, required: false)
    |> validate_required([:person_type, :first_name, :last_name])
  end


end
