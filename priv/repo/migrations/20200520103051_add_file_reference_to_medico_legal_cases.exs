defmodule MyHive.Repo.Migrations.AddFileReferenceToMedicoLegalCases do
  use Ecto.Migration

  def change do
    alter table(:medico_legal_cases) do
      add :file_reference, :string
    end
  end
end
