defmodule MyHive.Repo.Migrations.AddResetEmailToken do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :reset_email_token, :string
    end
  end
end
