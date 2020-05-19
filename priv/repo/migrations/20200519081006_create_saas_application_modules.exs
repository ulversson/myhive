defmodule MyHive.Repo.Migrations.CreateSaasApplicationModules do
  use Ecto.Migration

  def change do
    create table(:saas_application_modules) do
      add :name, :string
      add :description, :text
      add :icon, :string
      add :monthly_price, :decimal
      add :short_name, :string
      timestamps()
    end

  end
end
