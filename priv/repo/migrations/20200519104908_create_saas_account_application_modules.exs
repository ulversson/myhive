defmodule MyHive.Repo.Migrations.CreateSaasAccountApplicationModules do
  use Ecto.Migration

  def change do
    create table(:saas_account_application_modules) do
      add :application_module_id, :integer
      add :saas_account_id, :integer
      add :activated_at, :naive_datetime
      add :deactivated_at, :naive_datetime

      timestamps()
    end

  end
end
