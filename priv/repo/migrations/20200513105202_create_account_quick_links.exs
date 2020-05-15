defmodule MyHive.Repo.Migrations.CreateAccountQuickLinks do
  use Ecto.Migration

  def change do
    create table(:account_quick_links) do
      add :link_url, :string
      add :name, :string
      add :user_id, :integer

      timestamps()
    end

  end
end
