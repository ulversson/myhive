defmodule MyHive.Saas.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User

  schema "saas_accounts" do
    field :max_users, :integer
    field :name, :string
    many_to_many :users, User, join_through: "saas_accounts_users"
    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :max_users])
    |> validate_required([:name, :max_users])
  end
end
