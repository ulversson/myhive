defmodule MyHive.EmailTemplates.Services.OutlookPdfUploader do

  alias MyHive.FileManager.AutoFileAssetUploader
  alias MyHive.CaseManagement.MedicoLegalCase
  alias MyHive.CaseManagement
  alias MyHive.EmailTemplates.EmailFromTemplate

  def call(pdf_path, email) do
    mlc = CaseManagement.get_medico_legal_case!(email.medico_legal_case_id)
    {:ok, folders} = MedicoLegalCase.correspondence_folders(mlc)
    AutoFileAssetUploader.call(
      pdf_path,
      List.first(folders),
      "#{document_name(email)}")
    :ok
  end

  defp document_name(email) do
    "Email #{EmailFromTemplate.processed_subject(email)} sent - #{current_timestamp()}.pdf"
  end

  defp current_timestamp() do
    {:ok, time} = Timex.now("Europe/London")
      |> Timex.format("%d/%m/%Y %H_%M", :strftime)
    time
  end


end
