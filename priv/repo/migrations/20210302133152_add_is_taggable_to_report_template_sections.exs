defmodule MyHive.Repo.Migrations.AddIsTaggableToReportTemplateSections do
  use Ecto.Migration

  def change do
    alter table(:report_template_sections) do
      add :is_taggable, :boolean, default: false
    end
  end
end
