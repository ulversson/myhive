defmodule MyHive.Reports.ReportSection do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Reports.ReportTemplateSection

  @derive {
    Jason.Encoder,
    only: [:letter, :name, :is_letter_visible, :id]
  }
  schema "reports_sections" do
    field :name, :string
    field :letter, :string
    field :is_letter_visible, :boolean, default: false
    has_many :reports_sections, ReportTemplateSection
    timestamps()
  end

  @doc false
  def changeset(report_section, attrs) do
    report_section
    |> cast(attrs, [:name, :letter, :is_letter_visible])
    |> validate_required([:name, :letter, :is_letter_visible])
  end
end
