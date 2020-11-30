defmodule MyHive.Repo.Migrations.CreateEmailTemplateTemplateVaribales do
  use Ecto.Migration

  def change do
    create table(:email_template_template_varibales) do
      add :email_template_id, :integer
      add :template_variable_id, :integer

      timestamps()
    end

  end
end
