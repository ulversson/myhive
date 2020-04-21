defmodule MyHive.Repo.Migrations.AddAccountIdToMedicoLegalCases do
  use Ecto.Migration

  def change do
    alter table(:medico_legal_cases) do
      add :account_id, :integer
    end
  end
end
