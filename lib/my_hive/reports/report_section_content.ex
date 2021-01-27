defmodule MyHive.Reports.ReportSectionContent do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyHive.Reports.{
    ReportSection,
    ReportTemplate,
    ReportTemplateSection,
  }
  alias MyHive.Accounts.User

  schema "report_section_contents" do
    field :content, :string
    field :header, :string
    field :order, :integer
    belongs_to :report_section, ReportSection
    belongs_to :report_template, ReportTemplate
    belongs_to :report_template_section, ReportTemplateSection
    belongs_to :user, User
    belongs_to :user_report, UserMedicoLegalCaseReport
    timestamps()
  end

  @doc false
  def changeset(report_section_content, attrs) do
    report_section_content
    |> cast(attrs, [:report_template_section_id, :content, :order, :header, :report_template_id, :report_section_id, :user_id, :user_report_id])
    |> validate_required([:report_template_section_id, :content, :order, :header, :report_template_id, :report_section_id, :user_id])
  end
end
