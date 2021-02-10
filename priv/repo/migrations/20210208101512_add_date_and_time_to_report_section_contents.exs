defmodule MyHive.Repo.Migrations.AddDateAndTimeToReportSectionContents do
  use Ecto.Migration

  def change do
     alter table(:report_section_contents) do 
       add :timestamp, :string
       add :occurred_on, :date
    end
  end
end
