defmodule MyHive.Blog.BlogPostTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Blog.{
    Tag, Post
  }

  schema "blog_posts_tags" do
    belongs_to :post, Post
    belongs_to :tag, Tag
    timestamps()
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:post_id, :tag_id])
    |> validate_required([:post_id, :tag_id])
  end

end
