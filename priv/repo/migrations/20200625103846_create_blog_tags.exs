defmodule MyHive.Repo.Migrations.CreateBlogTags do
  use Ecto.Migration

  def change do
    create table(:blog_tags) do
      add :name, :string, null: false
      timestamps()
    end
    create index(:blog_tags, ["lower(name)"], unique: true)

    create table(:blog_posts_tags) do
      add :tag_id, references(:blog_tags)
      add :post_id, references(:blog_posts)
    end
    create index(:blog_posts_tags, [:tag_id, :post_id], unique: true)

  end
end
