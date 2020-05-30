defmodule MyHive.Repo.Migrations.AddUsernameSlugToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slug, :string
    end
  end
end
