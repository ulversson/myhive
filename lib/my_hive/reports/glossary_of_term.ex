defmodule MyHive.Reports.GlossaryOfTerm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reports_glossary_of_terms" do
    field :description, :string
    field :name, :string
    field :letter, :string
    field :short_name, :string
    timestamps()
  end

  @doc false
  def changeset(glossary_of_term, attrs) do
    glossary_of_term
    |> cast(attrs, [:name, :description, :letter, :short_name])
    |> add_letter()
    |> validate_required([:name, :description, :letter])
  end

  defp add_letter(changeset) do
    name = get_change(changeset, :name)
    if name do 
      put_change(changeset, :letter, String.first(name))
    else
      changeset
    end
  end
end
