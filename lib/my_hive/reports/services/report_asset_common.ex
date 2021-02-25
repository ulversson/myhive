defmodule MyHive.Reports.ReportAssetCommon do 

  alias MyHive.{Repo, Reports}
  alias MyHive.Reports.{
    ReportHtmlRenderer,
    ReportPdfRenderer,
    ReportPdfRenderer2,
    ReportPdfUploader
  }
  alias MyHive.FileManager.FileAsset
  alias MyHive.FileManager.FileManagerHoover
  alias MyHive.FileManager

  def save_report_in_file_manager(report, save_doc) when save_doc == "true" do 
    rep_html = report.id |> ReportHtmlRenderer.call()
    pdf_path = if (report.report_template.code == "lt") do
      ReportPdfRenderer.call(rep_html, report.id)
        |> elem(1)
    else
      ReportPdfRenderer2.call(rep_html, report.id)
        |> elem(1)
    end
    {:ok, asset} = ReportPdfUploader.call(report, pdf_path) 
    File.rm("/tmp/#{report.id}.pdf")
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