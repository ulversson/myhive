defmodule MyHive.Repo.Migrations.CreateEmailInboxLastSearches do
  use Ecto.Migration

  def change do
    create table(:email_inbox_last_searches) do
      add :provider_id, :integer
      add :medico_legal_case_id, :integer
      add :user_id, :integer
      add :last_searched_at, :naive_datetime

      timestamps()
    end

  end
end
