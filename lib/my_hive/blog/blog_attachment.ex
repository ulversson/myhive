defmodule MyHive.Blog.BlogAttachment do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.Blog.Post

  @derive {
    Jason.Encoder,
    only: [:filename, :id, :size, :content_type]
  }
  schema "blog_attachments" do
    belongs_to :user, User
    belongs_to :post, Post
    field :filename, :string
    field :content_type, :string
    field :path, :string
    field :size, :string
    timestamps()
  end

  @doc false
  def changeset(blog_attachment, attrs) do
    blog_attachment
    |> cast(attrs, [:path, :size, :user_id, :filename, :content_type])
    |> validate_required([:user_id, :filename, :path, :content_type])
  end
end
