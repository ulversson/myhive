defmodule MyHive.Repo.Migrations.AddDowToReportSectionContents do
  use Ecto.Migration

  def change do
    alter table(:report_section_contents) do
      add :show_day_of_week, :boolean, default: false
    end
  end
end
