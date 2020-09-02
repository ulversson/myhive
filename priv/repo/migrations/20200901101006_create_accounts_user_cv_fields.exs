defmodule MyHive.Repo.Migrations.CreateAccountsUserCvFields do
  use Ecto.Migration

  def change do
    create table(:accounts_user_cv_fields) do
      add :cv_field_id, :integer
      add :user_id, :integer
      add :cv_id, :integer
      add :order, :integer
      timestamps()
    end

  end
end
