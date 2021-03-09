defmodule MyHive.Reports.UserMedicoLegalCaseReport do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Repo.ReportSectionContent
  alias MyHive.Reports.{
    ReportTemplate,
    ReportSectionContent,
    ReportGlossaryOfTerm
  }
  alias MyHive.FileManager.Folder
  alias MyHive.Accounts.User
  alias MyHive.CaseManagement.MedicoLegalCase

  @derive {
    Jason.Encoder,
    only: [
      :medico_legal_case_id, :user, :unique_key,
      :folder, :report_template, :report_section_contents
    ]
  }
  schema "reports_user_medico_legal_cases" do
    field :file_asset_id, :binary
    field :unique_key, :string
    belongs_to :medico_legal_case, MedicoLegalCase
    belongs_to :user, User
    belongs_to :folder, Folder, type: :binary
    belongs_to :report_template, ReportTemplate
    has_many :report_section_contents, ReportSectionContent, foreign_key: :user_report_id
    has_many :report_glossary_of_terms, ReportGlossaryOfTerm
    timestamps()
  end

  @doc false
  def changeset(user_medico_legal_case_report, attrs) do
    user_medico_legal_case_report
    |> cast(attrs, [:user_id, :medico_legal_case_id, :file_asset_id, :user_id, :unique_key, :folder_id, :report_template_id])
    |> validate_required([:user_id, :medico_legal_case_id, :report_template_id])
  end
end
