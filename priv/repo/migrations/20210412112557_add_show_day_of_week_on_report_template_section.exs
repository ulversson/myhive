defmodule MyHive.Repo.Migrations.AddShowDayOfWeekOnReportTemplateSection do
  use Ecto.Migration

  def change do
    alter table(:report_template_sections) do
      add :show_day_of_week, :boolean, default: false
    end
  end
end
