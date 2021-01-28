defmodule MyHive.Reports.UserReportUpdateProcessor do

  import MyHive.Reports.ReportAssetCommon
  alias MyHive.FileManager.FileManagerHoover
  alias MyHive.{
    Reports,
    Repo, 
    FileManager
  }
  alias MyHive.Reports.{
    UserMedicoLegalCaseReport
  }

  def call(%{"report_template_sections" => sections} = params, save_doc) do
    report = Reports.by_id(params["id"])
    Repo.transaction(fn ->
      report.report_section_contents
        |> Enum.with_index
        |> Enum.each(fn {section, index} ->
          form_section_data = Enum.at(sections, index)
          changeset = form_section_data |> elem(1)
          Reports.update_content(section, changeset)
        end)          
      report = Reports.update_report(report, %{
        folder_id: params["folder_id"],
        user_id: params["user_id"]
      })
      unless (is_nil(report.file_asset_id)) do
        file_asset = FileManager.get_file_asset!(report.file_asset_id)
        unless (is_nil(file_asset)) do 
          FileManagerHoover.hard_delete_item(file_asset)
        end
      end
    end)
    report = Reports.by_id(params["id"])
    save_report_in_file_manager(report, save_doc)
  end

end