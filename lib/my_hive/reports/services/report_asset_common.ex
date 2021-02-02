defmodule MyHive.Reports.ReportAssetCommon do 

  alias MyHive.{Repo, Reports}
  alias MyHive.Reports.{
    ReportHtmlRenderer,
    ReportPdfRenderer,
    ReportPdfUploader
  }
  alias MyHive.FileManager.FileAsset
  alias MyHive.FileManager.FileManagerHoover
  alias MyHive.FileManager

  def save_report_in_file_manager(report, save_doc) when save_doc == "true" do 
    pdf_path = report.id
      |> ReportHtmlRenderer.call()
      |> ReportPdfRenderer.call(report.id)
      |> elem(1)
    {:ok, asset} = ReportPdfUploader.call(report, pdf_path) 
    report_upate_with_asset(report, asset)
  end

  def save_report_in_file_manager(report, save_doc) when save_doc != "true" do
    unless (is_nil(report.file_asset_id)) do
      file_asset = FileManager.get_file_asset!(report.file_asset_id)
      unless (is_nil(file_asset)) do 
        FileManagerHoover.hard_delete_item(file_asset)
      end
      Reports.update_document(report, nil, nil)
    else
      report
    end
  end

  def report_upate_with_asset(report, asset) do
    asset
      |> FileAsset.changeset(%{folder_id: report.folder_id})
      |> Repo.update()
      |> elem(1)
    Reports.update_document(report, asset.id, report.folder_id)
  end

end