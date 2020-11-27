defmodule MyHive.Repo.Migrations.CreateOauth2Credentials do
  use Ecto.Migration

  def change do
    create table(:oauth2_credentials) do
      add :provider_id, :integer
      add :user_id, :integer
      add :email, :string
      add :name, :string
      add :token, :text
      add :refresh_token, :text
      add :expires_at, :naive_datetime

      timestamps()
    end

  end
end
