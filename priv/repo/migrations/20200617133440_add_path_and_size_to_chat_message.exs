defmodule MyHive.Repo.Migrations.AddPathAndSizeToChatMessage do
  use Ecto.Migration

  def change do
    alter table(:chat_messages) do
      add :path, :string
      add :size, :integer
    end
  end
end
