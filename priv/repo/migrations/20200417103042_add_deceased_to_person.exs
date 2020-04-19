defmodule MyHive.Repo.Migrations.AddDeceasedToPerson do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add :deceased, :boolean, default: false
    end
  end
end
