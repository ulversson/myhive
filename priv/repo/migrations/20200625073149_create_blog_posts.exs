defmodule MyHive.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create table(:blog_posts) do
      add :author_id, :integer
      add :title, :string
      add :body, :text
      add :post_type, :string
      add :slug, :string

      timestamps()
    end

  end
end
