defmodule MyHive.Repo.Migrations.CreateShareablesAuthorization do
  use Ecto.Migration

  def change do
    create table(:shareable_authorizations) do
      add :first_name, :string
      add :last_name, :string
      add :token, :string
      add :shareable_directory_id, :integer
      add :email, :string

      timestamps()
    end

  end
end
