defmodule MyHive.Saas.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.Saas.{
    Logo, CaseFolderTree
  }

  schema "saas_accounts" do
    field :max_users, :integer
    field :name, :string
    many_to_many :users, User, join_through: "saas_accounts_users"
    embeds_one :logo, Logo,  on_replace: :delete
    has_one :address, MyHive.ContactBook.Address,
      foreign_key: :addressable_id
    has_many :case_folder_trees, CaseFolderTree, foreign_key: :saas_account_id
    timestamps()
  end

  @doc false

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :max_users])
    |> cast_embed(:logo)
    |> cast_assoc(:address, required: false)
    |> validate_required([:name, :max_users])
  end
end
