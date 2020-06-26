defmodule MyHive.Blog do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Blog.{
    Post,
    Tag,
    BlogAttachment
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

end
