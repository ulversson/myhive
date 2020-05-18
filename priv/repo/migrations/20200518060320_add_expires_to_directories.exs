defmodule MyHive.Repo.Migrations.AddExpiresToDirectories do
  use Ecto.Migration

  def change do
    alter table(:shareable_directories) do
      add :expires, :date
    end
  end
end
