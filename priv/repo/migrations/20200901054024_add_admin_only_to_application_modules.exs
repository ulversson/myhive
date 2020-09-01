defmodule MyHive.Repo.Migrations.AddAdminOnlyToApplicationModules do
  use Ecto.Migration

  def change do
    alter table(:saas_application_modules) do
      add :admin_only, :boolean, default: false
    end
  end
end
