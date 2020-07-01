defmodule MyHive.Repo.Migrations.AddColorAndCalIdToEvents do
  use Ecto.Migration

  def change do
    alter table(:calendar_events) do
      add :calendar_id, :integer
      add :color, :string
    end
  end
end
