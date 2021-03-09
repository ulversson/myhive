defmodule MyHive.Repo.Migrations.MakeReportTemplateSectionOptional do
  use Ecto.Migration

  def change do
    alter table(:report_template_sections) do
      add :is_optional, :boolean, default: false
    end
  end
end
