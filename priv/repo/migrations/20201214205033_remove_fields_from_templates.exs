defmodule MyHive.Repo.Migrations.RemoveFieldsFromTemplates do
  use Ecto.Migration

  def change do
    alter table(:email_templates) do
      remove :subject, :string
      remove :description, :string
      remove :include_case_reference, :boolean
    end

  end
end
