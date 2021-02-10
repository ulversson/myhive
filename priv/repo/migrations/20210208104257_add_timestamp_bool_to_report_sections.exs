defmodule MyHive.Repo.Migrations.AddTimestampBoolToReportSections do
  use Ecto.Migration

  def change do
     alter table(:report_template_sections) do 
       add :has_timestamp, :boolean, default: false 
    end
  end
end
