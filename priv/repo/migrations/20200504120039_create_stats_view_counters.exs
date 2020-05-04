defmodule MyHive.Repo.Migrations.CreateStatsViewCounters do
  use Ecto.Migration

  def change do
    create table(:stats_view_counters) do
      add :countable_id, :integer
      add :countable_type, :string
      add :viewed_by, :integer
      timestamps()
    end
    create(index(:stats_view_counters, [:viewed_by, :countable_id]))
  end
end
