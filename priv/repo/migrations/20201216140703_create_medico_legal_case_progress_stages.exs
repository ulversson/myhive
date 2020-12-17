defmodule MyHive.Repo.Migrations.CreateMedicoLegalCaseProgressStages do
  use Ecto.Migration

  def change do
    create table(:medico_legal_case_progress_stages) do
      add :partial_percentage, :decimal
      add :order, :integer
      add :name, :string
      add :icon, :string
      timestamps()
    end

  end
end
