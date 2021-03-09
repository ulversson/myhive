defmodule MyHive.Reports.ReportGlossaryOfTerm do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Reports.{
    UserMedicoLegalCaseReport,
    GlossaryOfTerm
  }
  schema "user_reports_glossary_of_terms" do
    belongs_to :user_medico_legal_case_report, UserMedicoLegalCaseReport
    belongs_to :glossary_of_term, GlossaryOfTerm
    field :content, :string
    timestamps()
  end

  @doc false
  def changeset(report_glossary_of_term, attrs) do
    report_glossary_of_term
    |> cast(attrs, [:user_medico_legal_case_report_id, :glossary_of_term_id, :content])
    |> validate_required([:user_medico_legal_case_report_id, :glossary_of_term_id, :content])
  end
end
