defmodule MyHive.Repo.Migrations.CreateReportsSections do
  use Ecto.Migration

  def change do
    create table(:reports_sections) do
      add :name, :string
      add :letter, :string
      add :is_letter_visible, :boolean, default: false
      timestamps()
    end

  end
end
