defmodule MyHive.Accounts.QuickLink do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User

  schema "account_quick_links" do
    field :link_url, :string
    field :name, :string
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(quick_link, attrs) do
    quick_link
    |> cast(attrs, [:link_url, :name, :user_id])
    |> validate_required([:link_url, :name, :user_id])
  end
end
