defmodule MyHive.Repo.Migrations.CreateSaasAccountsUsers do
  use Ecto.Migration

  def change do
    create table(:saas_accounts_users) do
      add :account_id, :integer
      add :user_id, :integer

      timestamps()
    end
    create(index(:saas_accounts_users, [:account_id]))
    create(index(:saas_accounts_users, [:user_id]))
    create(
      unique_index(:saas_accounts_users, [:user_id, :account_id], name: :user_id_account_id_unique_index)
    )
  end
end
