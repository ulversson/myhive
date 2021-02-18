defmodule MyHive.Repo.Migrations.AddDefaultContentToReportTemplateSection do
  use Ecto.Migration

  def change do
    alter table(:report_template_sections) do
      add :default_content, :text
    end
  end
end
