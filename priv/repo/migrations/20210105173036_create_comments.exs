defmodule MyHive.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :parent_id, :binary
      add :body, :text
      add :commentable_id, :integer
      add :commentable_type, :string
      add :commented_by, :integer
      add :commented_at, :naive_datetime

      timestamps()
    end

  end
end
