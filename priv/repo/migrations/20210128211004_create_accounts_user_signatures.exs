defmodule MyHive.Repo.Migrations.CreateAccountsUserSignatures do
  use Ecto.Migration

  def change do
    create table(:accounts_user_signatures) do
      add :user_id, :integer
      add :image_content, :text
      add :content_type, :string
      timestamps()
    end

  end
end
