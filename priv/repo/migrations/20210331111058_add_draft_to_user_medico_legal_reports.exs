defmodule MyHive.Repo.Migrations.AddDraftToUserMedicoLegalReports do
  use Ecto.Migration

  def change do
    alter table(:reports_user_medico_legal_cases) do
      add :draft, :boolean, default: true
    end
  end
end
