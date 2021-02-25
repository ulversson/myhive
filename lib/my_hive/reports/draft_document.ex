defmodule MyHive.Reports.DraftDocument do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyHive.Reports.ReportTemplate
  alias MyHive.CaseManagement.MedicoLegalCase

  schema "reports_draft_documents" do
    field :document_json, :map
    field :unique_key, :string
    field :user_id, :integer
    belongs_to :report_template, ReportTemplate
    belongs_to :medico_legal_case, MedicoLegalCase
    timestamps()
  end

  @doc false
  def changeset(draft_document, attrs) do
    draft_document
    |> cast(attrs, [:unique_key, :document_json, :user_id, :medico_legal_case_id, :report_template_id])
    |> validate_required([:unique_key, :document_json, :user_id, :medico_legal_case_id, :report_template_id])
  end
end
