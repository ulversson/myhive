defmodule MyHiveWeb.Api.V1.ChatUploadController do
  use MyHiveWeb, :controller
  use Tus.Controller
  alias MyHive.Chat
  alias MyHive.Chat.Services.{
    ChatMessageFileServer,
    ChatAttachmentHoover
  }

  def on_begin_upload(_file) do
    :ok
  end

  def index(conn, %{"conversation_id" => conv_id, "user_id" => user_id}) do
    attachment = Chat.unsaved_attachment(conv_id, user_id)
    conn |> render("attachment.json", attachment: attachment)
  end

  def on_complete_upload(file) do
    file_map =  Enum.into file.metadata, %{}
      |> Map.put("path", file.path)
      |> Map.put("size", file.size)
    Chat.create_unsaved_attachment(file_map)
  end

  def destroy(conn, %{"attachment_id" => id}) do
    ChatAttachmentHoover.call(id)
    conn |> json(%{"status" => "ok"})
  end

end
