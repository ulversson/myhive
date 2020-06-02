defmodule MyHive.Repo.Migrations.ChangeStatsKeyToBinary do
  use Ecto.Migration

  def change do
    alter table(:stats_view_counters) do
      remove :countable_id, :integer
      add :countable_id, :uuid
    end
  end
end
