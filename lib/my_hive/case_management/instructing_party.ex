defmodule MyHive.CaseManagement.InstructingParty do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.ContactBook.Address
  schema "instructing_parties" do
    field :name, :string
    field :reference, :string
    has_many :all_addresses, Address,
    foreign_key: :addressable_id, on_replace: :delete
    has_many :addresses, Address,
      foreign_key: :addressable_id, on_replace: :delete,
      where: [addressable_type: "InstructingParty"]
    timestamps()
  end

  @doc false
  def changeset(instructing_party, attrs) do
    instructing_party
    |> cast(attrs, [:name, :reference])
    |> cast_assoc(:addresses, required: false)
    |> validate_required([:name], message: "cannot be blank")
  end
end
