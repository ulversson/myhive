defmodule MyHive.Repo.Migrations.CreateEmailTemplates do
  use Ecto.Migration

  def change do
    create table(:email_templates) do
      add :name, :string
      add :body, :text
      add :subject, :string
      add :include_case_reference, :boolean, default: false, null: false
      add :description, :text
      timestamps()
    end

  end
end
