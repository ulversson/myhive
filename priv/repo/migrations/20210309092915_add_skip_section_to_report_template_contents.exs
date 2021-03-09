defmodule MyHive.Repo.Migrations.AddSkipSectionToReportTemplateContents do
  use Ecto.Migration

  def change do
    alter table(:report_section_contents) do 
       add :is_skipped, :boolean, default: false
    end
  end
end
