defmodule MyHive.Repo.Migrations.CreateOrganizerCalendars do
  use Ecto.Migration

  def change do
    create table(:organizer_calendars) do
      add :name, :string
      add :owner_id, :integer

      timestamps()
    end

  end
end
