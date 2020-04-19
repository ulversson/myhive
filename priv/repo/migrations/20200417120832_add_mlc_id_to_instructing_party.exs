defmodule MyHive.Repo.Migrations.AddMlcIdToInstructingParty do
  use Ecto.Migration

  def change do
    alter table(:medico_legal_cases) do
      add :instructing_party_id, :integer
    end
  end
end
