defmodule MyHive.Repo.Migrations.CreateOauth2Providers do
  use Ecto.Migration

  def change do
    create table(:oauth2_providers) do
      add :name, :string
      add :enabled, :boolean, default: false, null: false
      add :icon, :string
      timestamps()
    end
  end
end
