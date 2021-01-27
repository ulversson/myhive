defmodule MyHive.Repo.Migrations.ChangeReportsTables do
  use Ecto.Migration

  def change do
    alter table(:report_section_contents) do
      add :user_report_id, :integer
    end
    alter table(:reports_user_medico_legal_cases) do
      add :folder_id, :bytea
    end
  end
end
