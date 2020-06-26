defmodule MyHive.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Blog.{
    PostTitleSlug,
    Tag,
    BlogAttachment
  }
  alias MyHive.Accounts.User
  alias MyHive.{
    Blog
  }
  schema "blog_posts" do
    field :body, :string
    field :post_type, :string
    field :slug, PostTitleSlug.Type
    field :title, :string
    field :tag_list, :string, virtual: true
    field :attachment_ids, :any, virtual: true
    has_many :attachments, BlogAttachment
    many_to_many :tags, Tag, join_through: "blog_posts_tags"
    belongs_to :author, User
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:author_id, :title, :attachment_ids, :body, :post_type, :slug, :tag_list])
    |> validate_required([:author_id, :title, :body, :post_type, :tag_list])
    |> PostTitleSlug.maybe_generate_slug
    |> process_tags()
    |> maybe_process_attachments()
  end

  def process_tags(changeset) do
    tag_list = changeset.changes
      |> Map.get(:tag_list, "")
      |> String.split(",")
      |> Enum.map(&(String.strip(&1)))
      |> Enum.reject(fn(name) -> name == "" end)
      |> Enum.map(&(String.downcase(&1)))
      |> Enum.uniq
      |> Enum.sort
    existing_tags = Blog.existing_tags(tag_list)
    tags = Enum.map(tag_list, fn(name) ->
    new_tag = struct(Tag, name: name)
      tag = Enum.find(existing_tags, new_tag, fn(existing_tag) ->
        existing_tag.name == name
      end)
    end)
    tag_changeset = Enum.map(tags, &Ecto.Changeset.change/1)
    changeset |> Ecto.Changeset.put_assoc(:tags, tag_changeset)
  end

  def maybe_process_attachments(changeset) do
    attachments_ids = get_change(changeset, :attachment_ids)
    if attachments_ids do
      attachments = Blog.attachments_by_ids(attachments_ids)
      put_assoc(changeset, :attachments, attachments)
    else
      changeset
    end
  end

end
