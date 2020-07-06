defmodule MyHive.Repo.Migrations.AddUntilDateToCalEvents do
  use Ecto.Migration

  def change do
    alter table(:calendar_events) do
      add :until_date, :naive_datetime
    end
  end
end
