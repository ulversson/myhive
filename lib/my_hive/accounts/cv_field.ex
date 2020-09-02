defmodule MyHive.Accounts.CVField do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts_cv_fields" do
    field :field_type, :string
    field :name, :string
    field :order, :integer
    timestamps()
  end

  @doc false
  def changeset(cv_field, attrs) do
    cv_field
    |> cast(attrs, [:name, :field_type, :order])
    |> validate_required([:name, :order, :field_type])
  end
end
