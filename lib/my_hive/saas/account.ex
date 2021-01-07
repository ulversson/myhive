defmodule MyHive.Saas.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias MyHive.Repo
  alias MyHive.Accounts.User
  alias MyHive.Saas.{
    Logo, CaseFolderTree, ApplicationModule
  }

  schema "saas_accounts" do
    field :max_users, :integer
    field :name, :string
    embeds_one :logo, Logo,  on_replace: :delete
    has_one :address, MyHive.ContactBook.Address,
      foreign_key: :addressable_id,
      where: [addressable_type: "Account"],
      on_replace: :update
    many_to_many :users, User, join_through: "saas_accounts_users"
    many_to_many :application_modules, ApplicationModule, join_through: "saas_account_application_modules"
    has_many :case_folder_trees, CaseFolderTree, foreign_key: :saas_account_id
    timestamps()
  end

  @doc false
  def preload_folder_trees(acc) do
    Repo.preload(acc,
        [case_folder_trees: (from t in CaseFolderTree, order_by: t.name)])
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :max_users])
    |> cast_embed(:logo)
    |> cast_assoc(:address, required: false)
    |> validate_required([:name, :max_users])
  end
end
