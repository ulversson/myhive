defmodule MyHive.Repo.Migrations.AddPasswordPathToFileAssets do
  use Ecto.Migration

  def change do
    alter table(:file_assets) do
      add :enc_password_path, :bytea
    end
  end
end
