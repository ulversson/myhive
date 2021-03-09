defmodule MyHive.Repo.Migrations.AddHasTocToReportTemplates do
  use Ecto.Migration

  def change do
    alter table(:report_templates) do
      add :toc_string, :string
    end
  end
end
