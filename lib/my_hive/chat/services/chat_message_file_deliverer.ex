defmodule MyHive.Chat.Services.ChatMessageFileDeliverer do

  alias MyHive.{Chat, Repo}
  alias MyHive.Chat.Services.ChatImageThumbnailer

  def call(attachment_id, chat_message) do
    Repo.transaction(fn ->
      attachment = attachment_id |> Chat.unsaved_attachment()
      Chat.update_message(chat_message, %{
        filename: attachment.filename,
        filetype: attachment.filetype,
        path: attachment.path,
        size: attachment.size
      })
      Repo.delete(attachment)
    end)
    chat_message = chat_message.id
      |> Chat.get_message!()
      |>  Repo.preload([:conversation, :user])
    ChatImageThumbnailer.call(chat_message)
    chat_message
  end

  def update_attachment_if_needed(payload, message) do
    if Map.has_key?(payload, "attachment_id") do
      call(payload["attachment_id"], message)
    else
      message
    end
  end

end
