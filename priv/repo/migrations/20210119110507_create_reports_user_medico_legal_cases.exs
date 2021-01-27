defmodule MyHive.Repo.Migrations.CreateReportsUserMedicoLegalCases do
  use Ecto.Migration

  def change do
    create table(:reports_user_medico_legal_cases) do
      add :user_id, :integer
      add :medico_legal_case_id, :integer
      add :file_asset_id, :binary
      add :report_template_id, :integer

      timestamps()
    end

  end
end
