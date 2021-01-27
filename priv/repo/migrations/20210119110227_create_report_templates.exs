defmodule MyHive.Repo.Migrations.CreateReportTemplates do
  use Ecto.Migration

  def change do
    create table(:report_templates) do
      add :name, :string
      add :code, :string
      add :has_title_page, :boolean, default: false, null: false
      add :enabled, :boolean, default: true, null: false
      timestamps()
    end

  end
end
