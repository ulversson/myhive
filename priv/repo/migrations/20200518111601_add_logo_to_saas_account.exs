defmodule MyHive.Repo.Migrations.AddLogoToSaasAccount do
  use Ecto.Migration

  def change do
    alter table(:saas_accounts) do
      add :logo, :map
    end
  end
end
