defmodule MyHive.Repo.Migrations.AddSubheadingToReportContent do
  use Ecto.Migration

  def change do
    alter table(:report_section_contents) do
      add :subheading, :string
    end
  end
end
