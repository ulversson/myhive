defmodule MyHive.Repo.Migrations.CreateAccountsCvFields do
  use Ecto.Migration

  def change do
    create table(:accounts_cv_fields) do
      add :name, :string
      add :field_type, :string
      add :order, :integer
      timestamps()
    end

  end
end
