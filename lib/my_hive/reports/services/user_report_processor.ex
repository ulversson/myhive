defmodule MyHive.Reports.UserReportProcessor do

  alias MyHive.Repo
  alias MyHive.Reports.{
    ReportSectionsCreator,
    UserMedicoLegalCaseReport,
    ReportHtmlRenderer,
    ReportPdfRenderer,
    ReportPdfUploader
  }

  def call(%{"report_template_sections" => sections} = params, user_id, save_doc) do
    report_data = Map.merge(params, %{"user_id" => user_id})
    report = Repo.transaction(fn ->
      report = %UserMedicoLegalCaseReport{}
        |> UserMedicoLegalCaseReport.changeset(report_data)
        |> Repo.insert()
        |> elem(1)

      ReportSectionsCreator.call(sections, report.id, user_id)
      Repo.preload(report, [
        :report_section_contents,
        :report_template,
        :user,
        :folder,
        :medico_legal_case
      ])
    end) |> elem(1)
    if (save_doc == "true") do
      pdf_path = report.id
        |> ReportHtmlRenderer.call()
        |> ReportPdfRenderer.call(report.id)
        |> elem(1)
      {:ok, asset} = ReportPdfUploader.call(report, pdf_path) 
      report_upate_with_asset(report, asset)
    else
      report
    end
  end

  defp report_upate_with_asset(report, asset) do 
    report 
     |> UserMedicoLegalCaseReport.changeset(%{
        file_asset_id: asset.id, folder_id: asset.folder_id
      })
     |> Repo.update()
     |> elem(1)
  end

end
