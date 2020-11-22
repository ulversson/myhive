defmodule MyHive.Repo.Migrations.CreateCvBundles do
  use Ecto.Migration

  def change do
    create table(:cv_bundles) do
      add :generated_by, :integer
      add :path, :string
      add :downloaded, :boolean, default: false, null: false

      timestamps()
    end

  end
end
