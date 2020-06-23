defmodule MyHive.Repo.Migrations.AddNoteIssuedToTimeEntries do
  use Ecto.Migration

  def change do
    alter table(:time_sheet_time_entries) do
      add :note_issued, :boolean, default: false
    end
  end
end
