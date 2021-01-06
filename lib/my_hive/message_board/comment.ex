defmodule MyHive.MessageBoard.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User

  schema "comments" do
    field :body, :string
    field :commentable_id, :integer
    field :commentable_type, :string
    field :commented_at, :naive_datetime
    field :parent_id, :binary
    belongs_to :user, User, foreign_key: :commented_by
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:parent_id, :body, :commentable_id, :commentable_type, :commented_by, :commented_at])
    |> validate_required([:body, :commentable_id, :commentable_type, :commented_by, :commented_at])
  end
end
