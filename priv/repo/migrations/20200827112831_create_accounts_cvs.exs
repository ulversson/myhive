defmodule MyHive.Repo.Migrations.CreateAccountsCvs do
  use Ecto.Migration

  def change do
    create table(:accounts_cvs) do
      add :path, :string
      add :user_id, :integer
      add :size, :integer
      add :name, :string
      timestamps()
    end

  end
end
