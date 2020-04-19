defmodule MyHive.Repo.Migrations.AddMedicoLegalCaseIdToCasePerson do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add(:medico_legal_case_id, :integer)
    end
    create index(:people, [:medico_legal_case_id])
  end
end
