defmodule MyHive.Repo.Migrations.CreateShareableDirectories do
  use Ecto.Migration

  def change do
    create table(:shareable_directories) do
      add :shared_by, :integer
      add :token, :string
      add :approved, :boolean, default: false, null: false
      add :viewed, :boolean, default: false, null: false
      add :note, :text
      add :emails, :string

      timestamps()
    end

  end
end
