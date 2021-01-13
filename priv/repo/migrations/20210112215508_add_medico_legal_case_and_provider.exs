defmodule MyHive.Repo.Migrations.AddMedicoLegalCaseAndProvider do
  use Ecto.Migration

  def change do
    alter table(:email_inbox_incoming_messages) do
      add :provider_id, :integer
      add :user_id, :integer
      add :sender_name, :string
      add :recipients_name, :string
    end
  end
end
