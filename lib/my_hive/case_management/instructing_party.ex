defmodule MyHive.CaseManagement.InstructingParty do
  use Ecto.Schema
  import Ecto.Changeset

  schema "instructing_parties" do
    field :name, :string
    field :reference, :string
    has_many :addresses, MyHive.ContactBook.Address, foreign_key: :addressable_id, on_replace: :delete
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
