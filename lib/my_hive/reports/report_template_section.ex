defmodule MyHive.Reports.ReportTemplateSection do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyHive.Reports.{
    ReportTemplate,
    ReportSection,
    ReportSectionContent
  }

  @derive {
    Jason.Encoder,
    only: [
      :report_template_id, :report_section_id, :id, 
      :is_multiple, :has_timestamp
    ]
  }
  schema "report_template_sections" do
    belongs_to :report_section, ReportSection
    belongs_to :report_template, ReportTemplate
    has_many :report_section_contents, ReportSectionContent
    field :is_multiple, :boolean, default: false
    field :has_timestamp, :boolean, default: false
    timestamps()
  end

  @doc false
  def changeset(report_template_section, attrs) do
    report_template_section
    |> cast(attrs, [:report_section_id, :report_template_id, :has_timestamp, :is_multiple])
    |> validate_required([:report_section_id, :report_template_id])
  end
end
