defmodule MyHive.Repo.Migrations.AddFieldsToNotifications do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      add :show_on_arrival, :boolean, default: false
      add :expires, :date
    end
  end
end
