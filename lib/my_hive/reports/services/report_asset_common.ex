defmodule MyHive.Reports.ReportAssetCommon do 

  alias MyHive.{Repo, Reports}
  alias MyHive.Reports.{
    ReportHtmlRenderer,
    ReportPdfRenderer2,
    ReportPdfUploader
  }
  alias MyHive.FileManager.FileAsset
  alias MyHive.FileManager.FileManagerHoover
  alias MyHive.FileManager

  def save_report_in_file_manager(report) do 
    rep_html = report.id |> ReportHtmlRenderer.call()
    pdf_path = ReportPdfRenderer2.call(rep_html, report.id, false, report.report_template.code)
        |> elem(1)
    pdf_path = process_toc_if_needed(report.report_template.toc_string, report, pdf_path)
    {:ok, asset} = ReportPdfUploader.call(report, pdf_path) 
    report_upate_with_asset(report, asset)
  end

  def report_upate_with_asset(report, asset) do
    asset
      |> FileAsset.changeset(%{folder_id: report.folder_id})
      |> Repo.update()
      |> elem(1)
    Reports.update_document(report, asset.id, report.folder_id)
  end

  def process_toc_if_needed(toc_string, report, pdf_path) when is_binary(toc_string) do
    if (String.length(toc_string) > 0) do
      apply(String.to_existing_atom(toc_module(report)), :call, [report, pdf_path]) 
    else
     pdf_path
    end  
  end

  def process_toc_if_needed(toc_string, _, pdf_path) when is_nil(toc_string) do
    pdf_path
  end

  def toc_module(report) do
    "Elixir.MyHive.Reports.TocParsers." <> Macro.camelize(report.report_template.code) <> "TocParser"
  end

end