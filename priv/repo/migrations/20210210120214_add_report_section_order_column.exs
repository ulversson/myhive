defmodule MyHive.Repo.Migrations.AddReportSectionOrderColumn do
  use Ecto.Migration

  def change do
     alter table(:report_template_sections) do 
       add :order, :integer
    end
  end
end
