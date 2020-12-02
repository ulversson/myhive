defmodule MyHive.Repo.Migrations.CreateSentEmails do
  use Ecto.Migration

  def change do
    create table(:sent_emails) do
      add :email_template_id, :integer
      add :email_body, :text
      add :from_user_id, :integer
      add :from_email_address, :string
      add :recipients, :string
      add :bcc_recipients, :string
      add :variables, :map
      add :medico_legal_case_id, :integer
      timestamps()
    end

  end
end
