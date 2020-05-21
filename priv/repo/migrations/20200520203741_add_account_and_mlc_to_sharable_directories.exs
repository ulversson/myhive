defmodule MyHive.Repo.Migrations.AddAccountAndMlcToSharableDirectories do
  use Ecto.Migration

  def change do
    alter table(:shareable_directories) do
      add :medico_legal_case_id, :integer
      add :saas_account_id, :integer
    end
    create index(:shareable_directories, [:medico_legal_case_id])
    create index(:shareable_directories, [:saas_account_id])

  end
end
