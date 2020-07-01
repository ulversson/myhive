defmodule MyHive.Repo.Migrations.CreateCalendarEvents do
  use Ecto.Migration

  def change do
    create table(:calendar_events) do
      add :name, :string
      add :description, :text
      add :start_date, :naive_datetime
      add :end_date, :naive_datetime
      add :all_day, :boolean, default: false, null: false
      add :recurrence, :text

      timestamps()
    end

  end
end
