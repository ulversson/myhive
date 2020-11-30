defmodule MyHive.Repo.Migrations.CreateEmailTemplatesVariables do
  use Ecto.Migration

  def change do
    create table(:email_templates_variables) do
      add :name, :string
      add :code, :string
      add :input_type, :string
      add :description, :text
      timestamps()
    end

  end
end
