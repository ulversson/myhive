defmodule MyHive.Repo.Migrations.RemoveSummaryColumn do
  use Ecto.Migration

  def change do
    alter table(:medico_legal_cases) do
      remove :case_summary, :text
    end
  end
end
