defmodule MyHive.Repo.Migrations.AddUserSharedRoot do
  use Ecto.Migration

  def change do
    alter table(:folders) do
      add :user_shared_root, :boolean, default: false
    end
  end
end
