defmodule MyHive.Repo.Migrations.CreateNotificatons do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :recipient_id, :integer
      add :topic, :string
      add :body, :text
      add :icon, :string
      add :sender_id, :integer
      add :viewed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
