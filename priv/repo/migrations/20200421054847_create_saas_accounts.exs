defmodule MyHive.Repo.Migrations.CreateSaasAccounts do
  use Ecto.Migration

  def change do
    create table(:saas_accounts) do
      add :name, :string
      add :max_users, :integer

      timestamps()
    end

  end
end
