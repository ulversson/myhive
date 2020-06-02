defmodule MyHive.Repo.Migrations.ChangeMlcPart1 do
  use Ecto.Migration

  def change do
    alter table(:medico_legal_cases) do
      add :instructed_by, :binary
      remove :claimant_defendant
    end
  end
end
