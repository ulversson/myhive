defmodule MyHive.Repo.Migrations.ChangeFileSizeToString do
  use Ecto.Migration

  def change do
    alter table(:file_assets) do
      modify(:size, :string)
    end
  end
end
