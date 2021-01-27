defmodule MyHive.Repo.Migrations.CreateReportTemplateSections do
  use Ecto.Migration

  def change do
    create table(:report_template_sections) do
      add :report_section_id, :integer
      add :report_template_id, :integer

      timestamps()
    end

  end
end
