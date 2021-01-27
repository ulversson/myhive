defmodule MyHive.Reports.GlossaryOfTerm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reports_glossary_of_terms" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(glossary_of_term, attrs) do
    glossary_of_term
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
