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
      :report_template_id, :report_section_id, :id, :default_content, :is_optional,
      :is_multiple, :is_taggable, :has_timestamp, :order, :report_section, :has_subheading,
      :show_day_of_week
    ]
  }
  schema "report_template_sections" do
    belongs_to :report_section, ReportSection
    belongs_to :report_template, ReportTemplate
    has_many :report_section_contents, ReportSectionContent
    field :is_multiple, :boolean, default: false
    field :is_taggable, :boolean, default: false
    field :is_optional, :boolean, default: false
    field :has_timestamp, :boolean, default: false
    field :has_subheading, :boolean, default: false
    field :order, :integer
    field :show_day_of_week, :boolean, default: false
    field :default_content, :string
    timestamps()
  end

  @doc false
  def changeset(report_template_section, attrs) do
    report_template_section
    |> cast(attrs, [:report_section_id, :report_template_id, :order, :has_subheading,
      :is_optional, :is_taggable, :has_timestamp, :is_multiple, :default_content, :show_day_of_week])
    |> validate_required([:report_section_id, :report_template_id])
  end
end
