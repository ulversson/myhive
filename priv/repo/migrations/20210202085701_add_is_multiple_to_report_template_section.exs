defmodule MyHive.Repo.Migrations.AddIsMultipleToReportTemplateSection do
  use Ecto.Migration

  def change do
    alter table(:report_template_sections) do 
       add :is_multiple, :boolean, default: false 
    end
  end
end
