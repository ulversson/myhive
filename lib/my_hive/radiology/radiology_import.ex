defmodule MyHive.Radiology.RadiologyImport do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.CaseManagement.MedicoLegalCase

  schema "radiology_imports" do
    field :description, :string
    field :name, :string
    field :result, :string
    field :error, :string
    field :path, :string
    belongs_to :medico_legal_case, MedicoLegalCase
    timestamps()
  end
  @doc false
  def changeset(radiology_import, attrs) do
    radiology_import
    |> cast(attrs, [:name, :description, :path, :result, :error, :medico_legal_case_id])
    |> validate_required([:name, :path, :medico_legal_case_id])
  end
end
