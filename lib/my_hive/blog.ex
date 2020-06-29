defmodule MyHive.Blog do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Blog.{
    Post,
    Tag,
    BlogAttachment,
    BlogPostTag
  }

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def existing_tags(tag_list) do
    from(t in Tag,
      where: t.name in ^tag_list)
    |> Repo.all()
  end

  def create_attachment(attrs \\ %{}) do
    %BlogAttachment{}
    |> BlogAttachment.changeset(attrs)
    |> Repo.insert()
  end

  def attachments_by_ids(attachment_ids) do
    from(a in BlogAttachment,
     where: a.id in ^attachment_ids)
     |> Repo.all()
  end

  def get_attachment!(id), do: Repo.get!(BlogAttachment, id)

  def delete_attachment(%BlogAttachment{} = attach) do
    Repo.delete(attach)
  end

  def all_posts_query() do
    from p in Post,
      preload: [:author, :tags, :attachments],
      order_by: [{:desc, :inserted_at}]
  end
  def all_posts() do
    all_posts_query() |> Repo.all()
  end

  def top_tags() do
    query = from bpt in BlogPostTag,
      join: t in assoc(bpt, :tag),
      join: p in assoc(bpt, :post),
      select: [t.name, count(bpt.post_id)],
      group_by: [bpt.tag_id, t.name],
      order_by: [count(bpt.post_id)]
    Enum.reverse(Repo.all(query))
  end

  def by_tag(tag_name) do
    query = by_tag_query(tag_name)
    Repo.all(query)
  end

  def by_tag_query(tag_name) do
    from p in Post,
      join: t in assoc(p, :tags),
      where: t.name == ^tag_name,
      order_by: [{:desc, :inserted_at}],
      preload: [:author, :tags, :attachments]
  end

  def get_post!(id) do
    Repo.get_by(Post, id: id)
  end

  def get_post_by_slug!(slug) do
    query = from p in Post,
      order_by: [{:desc, :inserted_at}],
      preload: [:author, :tags, :attachments],
      where: p.slug == ^slug
    Repo.one(query)
  end

end
