defmodule MyHive.Repo.Migrations.CreateReportSectionContents do
  use Ecto.Migration

  def change do
    create table(:report_section_contents) do
      add :report_template_section_id, :integer
      add :content, :text
      add :order, :integer
      add :header, :string
      add :report_template_id, :integer
      add :report_section_id, :integer
      add :user_id, :integer

      timestamps()
    end

  end
end
