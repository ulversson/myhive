defmodule MyHive.Reports.UserReportProcessor do

  import MyHive.Reports.ReportAssetCommon
  alias MyHive.Repo
  alias MyHive.Reports.{
    ReportSectionsCreator,
    UserMedicoLegalCaseReport
  }

  def call(%{"report_template_sections" => sections} = params, save_doc) do
      case create_report(params) do 
        {:ok, report} -> 
          ReportSectionsCreator.call(sections, report.id, params["user_id"])
          report = Repo.preload(report, [
            :report_section_contents,
            :report_template,
            :user,
            :folder,
            :medico_legal_case
          ])
          save_report_in_file_manager(report, save_doc)
        {:error, changeset} ->  
          false
      end
  end

  def create_report(params) do 
    %UserMedicoLegalCaseReport{}
        |> UserMedicoLegalCaseReport.changeset(params)
        |> Repo.insert()
  end

end
