defmodule MyHive.Reports.ReportPdfUploader do 
 
  alias MyHive.FileManager
  alias MyHive.FileManager.AutoFileAssetUploader


	def call(report, pdf_path) do 
    folder = FileManager.get_folder!(report.folder_id)
    AutoFileAssetUploader.call(
      pdf_path, folder, document_name(report)
    )
	end

  defp document_name(report) do 
    timestamp = Timex.now |> Timex.format("%d/%m/%Y", :strftime) |> elem(1)
    "Rpt #{report.report_template.name} generated #{timestamp}.pdf"
  end

end