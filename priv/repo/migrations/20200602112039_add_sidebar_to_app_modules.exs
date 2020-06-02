defmodule MyHive.Repo.Migrations.AddSidebarToAppModules do
  use Ecto.Migration

  def change do
    alter table(:saas_application_modules) do
      add :sidebar, :boolean, default: true
    end
  end
end
