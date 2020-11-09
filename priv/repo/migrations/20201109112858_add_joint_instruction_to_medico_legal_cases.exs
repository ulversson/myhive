defmodule MyHive.Repo.Migrations.AddJointInstructionToMedicoLegalCases do
  use Ecto.Migration

  def change do
    alter table(:medico_legal_cases) do
      add :joint_instruction, :boolean, default: false
    end
  end
end
