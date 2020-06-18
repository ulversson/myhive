defmodule MyHive.Repo.Migrations.AddFieldsToChatMessage do
  use Ecto.Migration

  def change do
    alter table(:chat_messages) do
      add :filename, :string
      add :filetype, :string
    end
  end
end
