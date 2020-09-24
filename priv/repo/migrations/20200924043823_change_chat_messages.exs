defmodule MyHive.Repo.Migrations.ChangeChatMessages do
  use Ecto.Migration

  def change do
    alter table(:chat_messages) do
      modify(:size, :string)
    end
  end
end
