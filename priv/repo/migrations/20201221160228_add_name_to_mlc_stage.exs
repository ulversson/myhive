defmodule MyHive.Repo.Migrations.AddNameToMlcStage do
  use Ecto.Migration

  def change do
    alter table(:medico_legal_case_statuses) do
      add :name, :string
    end
  end
end
