defmodule MyHive.CaseManagement.InstructingParty do
  use Ecto.Schema
  import Ecto.Changeset

  schema "instructing_parties" do
    field :name, :string
    field :contact_name, :string
    has_many :addresses, MyHive.ContactBook.Address, foreign_key: :addressable_id
    timestamps()
  end

  @doc false
  def changeset(instructing_party, attrs) do
    instructing_party
    |> cast(attrs, [:name, :contact_name])
    |> cast_assoc(:addresses, required: false)
    |> validate_required([:name])
  end
end
