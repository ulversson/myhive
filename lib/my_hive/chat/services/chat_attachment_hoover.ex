defmodule MyHive.Chat.Services.ChatAttachmentHoover do

  alias MyHive.Chat
  alias MyHive.Chat.Services.ChatMessageFileServer

  def call(attachment_id) do
    {:ok, att} = attachment_id
      |> Chat.unsaved_attachment()
      |> Chat.delete_unsaved_attachment()
    file_path = ChatMessageFileServer.call(att)
    File.rm(file_path)
  end

end
