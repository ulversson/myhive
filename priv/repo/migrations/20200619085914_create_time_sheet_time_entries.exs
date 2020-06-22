defmodule MyHive.Repo.Migrations.CreateTimeSheetTimeEntries do
  use Ecto.Migration

  def change do
    create table(:time_sheet_time_entries) do
      add :medico_legal_case_id, :integer
      add :owner_id, :integer
      add :start_date, :naive_datetime
      add :end_date, :naive_datetime
      add :description, :text
      add :note, :text

      timestamps()
    end

  end
end
