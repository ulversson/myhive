defmodule MyHive.Repo.Migrations.AddFieldValueToCvFields do
  use Ecto.Migration

  def change do
    alter table(:accounts_user_cv_fields) do
      add :field_value, :text
    end
  end
end
