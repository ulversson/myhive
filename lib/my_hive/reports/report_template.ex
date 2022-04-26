defmodule MyHive.Reports.ReportTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Reports.{
    ReportSection,
    ReportTemplateSection
  }
  @derive {
    Jason.Encoder,
    only: [:code, :name, :has_title_page, :id,
    :enabled, :sections, :report_sections, :toc_string]
  }
  schema "report_templates" do
    field :code, :string
    field :has_title_page, :boolean, default: false
    field :has_glossary_of_terms, :boolean, default: false
    field :name, :string
    field :enabled, :boolean, default: true
    field :toc_string, :string
    has_many :report_sections, ReportTemplateSection
    many_to_many :sections, ReportSection, join_through: ReportTemplateSection
    timestamps()
  end

  @doc false
  def changeset(report_template, attrs) do
    report_template
    |> cast(attrs, [:name, :code, :has_title_page, :enabled, :toc_string, :has_glossary_of_terms])
    |> validate_required([:name, :code, :has_title_page])
  end
end