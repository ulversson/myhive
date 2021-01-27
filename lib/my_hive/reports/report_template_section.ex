defmodule MyHive.Reports.ReportTemplateSection do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyHive.Reports.{
    ReportTemplate,
    ReportSection
  }

  @derive {
    Jason.Encoder,
    only: [:report_template_id, :report_section_id, :id]
  }
  schema "report_template_sections" do
    belongs_to :report_section, ReportSection
    belongs_to :report_template, ReportTemplate
    timestamps()
  end

  @doc false
  def changeset(report_template_section, attrs) do
    report_template_section
    |> cast(attrs, [:report_section_id, :report_template_id])
    |> validate_required([:report_section_id, :report_template_id])
  end
end
