defmodule MyHive.Repo.Migrations.AddBlogUnsavedAttachments do
  use Ecto.Migration

  def change do
    create table(:blog_attachments) do
      add :user_id, :integer
      add :post_id, :integer
      add :filename, :string
      add :content_type, :string
      add :path, :string
      add :size, :integer
      timestamps()
    end
  end
end
