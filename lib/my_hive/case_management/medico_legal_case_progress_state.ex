defmodule MyHive.CaseManagement.MedicoLegalCaseProgressState do
  use Ecto.Schema
  import Ecto.Changeset

  schema "medico_legal_case_progress_stages" do
    field :icon, :string
    field :name, :string
    field :order, :integer
    field :partial_percentage, :decimal
    timestamps()
  end

  @doc false
  def changeset(medico_legal_case_progress_state, attrs) do
    medico_legal_case_progress_state
    |> cast(attrs, [:partial_percentage, :order, :name, :icon])
    |> validate_required([:partial_percentage, :order, :name, :icon])
  end
end
