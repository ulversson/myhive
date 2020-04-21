defmodule MyHive.Saas.AccountUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Saas.Account
  alias MyHive.Accounts.User
  schema "saas_accounts_users" do
    belongs_to :user, User
    belongs_to :account, Account, foreign_key: :account_id
    timestamps()
  end

  @doc false
  def changeset(account_user, attrs) do
    account_user
    |> cast(attrs, [:saas_account_id, :user_id])
    |> validate_required([:saas_account_id, :user_id])
  end
end
