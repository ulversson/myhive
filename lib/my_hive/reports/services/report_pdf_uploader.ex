defmodule MyHive.Reports.ReportPdfUploader do 
 
  alias MyHive.{FileManager, Repo}
  alias MyHive.FileManager.AutoFileAssetUploader


	def call(report, pdf_path) do 
    folder = FileManager.get_folder!(report.folder_id)
    AutoFileAssetUploader.call(
      pdf_path, folder, document_name(report)
    )
	end

  defp document_name(report) do 
    mlc = Repo.preload(report.medico_legal_case, [:patient])
    timestamp = Timex.now |> Timex.format("%d %B %Y", :strftime) |> elem(1)
    "#{report.report_template.name |> String.replace(" Template", "")} Re #{mlc.patient.last_name} #{timestamp}.pdf"
  end

end