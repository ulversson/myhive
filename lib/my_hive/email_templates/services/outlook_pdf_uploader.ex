defmodule MyHive.EmailTemplates.Services.OutlookPdfUploader do

  alias MyHive.FileManager.AutoFileAssetUploader
  alias MyHive.FileManager
  alias MyHive.EmailTemplates.EmailFromTemplate

  def call(pdf_path, email) do
    folder = FileManager.get_folder!(email.folder_id)
    AutoFileAssetUploader.call(
      pdf_path, folder, "#{document_name()}"
    )
    :ok
  end

  defp document_name() do
    "Email sent - #{current_timestamp()}.pdf"
  end

  defp current_timestamp() do
    {:ok, time} = Timex.now("Europe/London")
      |> Timex.format("%d/%m/%Y %H:%M", :strftime)
    time
  end


end
