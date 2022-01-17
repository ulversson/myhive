defmodule MyHiveWeb.Plugs.ShareableDirectoryNotifier do
  use Ecto.Schema
  alias MyHive.Notifications.{
    NotificationProtocol,
    WebSocket,
    NotificationPdfRenderer
  }
  alias MyHive.Shareable
  alias MyHive.CaseManagement.MedicoLegalCase
  alias MyHive.FileManager.AutoFileAssetUploader

  def call(notification, directory, action \\ "accessed") do
    directory = Shareable.preload_all(directory)
    send_notification(notification, directory, action)
  end

  defp send_notification(notification, directory, action) do
    web_socket = %WebSocket{
      topic: "notifications:#{directory.sharer.id}",
      event: "new_notification",
      payload: notification
    }
    NotificationProtocol.send(web_socket)
    pdf_path = NotificationPdfRenderer.call(notification, directory.first_name <> " " <> directory.last_name)
    {:ok, folders} = MedicoLegalCase.correspondence_folders(directory.medico_legal_case)
    AutoFileAssetUploader.call(pdf_path, List.first(folders), files_accessed_name(action))
  end

  defp name(dir) do
    "<strong>" <> dir.first_name <> " " <> dir.last_name <> "</strong>"
  end

  defp files_accessed_name(action) do
    now = Timex.now |> Timex.format("%d.%m.%Y %H:%M@hours", :strftime) |> elem(1)
    "Files #{action} #{now}.pdf"
  end
end
