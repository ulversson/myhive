defmodule MyHive.EmailInbox.Services.OutlookEmailContentUploader do
  alias MyHive.FileManager.AutoFileAssetUploader
  alias MyHive.{
    FileManager, IncomingMessages
  }

  def call(inbox_email_id, folder_id) do
    email = inbox_email_id |> IncomingMessages.find_by_id()
    pdf_path = PdfGenerator.generate(email.content, page_size: "A4") |> elem(1)
    folder = FileManager.get_folder!(folder_id)
    AutoFileAssetUploader.call(
      pdf_path, folder, document_name()
    )
    :ok
  end

  defp document_name() do
    "Email received - #{current_timestamp()}.pdf"
  end

  defp current_timestamp() do
    {:ok, time} = Timex.now("Europe/London")
      |> Timex.format("%d/%m/%Y %H:%M", :strftime)
    time
  end

end
