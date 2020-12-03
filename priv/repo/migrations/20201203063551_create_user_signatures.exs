defmodule MyHive.Repo.Migrations.CreateUserSignatures do
  use Ecto.Migration

  def change do
    create table(:user_signatures) do
      add :user_id, :integer
      add :content, :text
      add :active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
