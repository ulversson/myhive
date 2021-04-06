defmodule MyHive.Repo.Migrations.AddSubheadingToReportTemplateSection do
  use Ecto.Migration

  def change do
    alter table(:report_template_sections) do
      add :has_subheading, :boolean, default: false
    end
  end
end
