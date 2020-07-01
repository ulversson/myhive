defmodule MyHive.Repo.Migrations.AddOwnerIdToCalendars do
  use Ecto.Migration

  def change do
    alter table(:calendar_events) do
      add :owner_id, :integer
    end
  end
end
