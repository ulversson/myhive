defmodule MyHive.Chat.Services.ChatImageThumbnailer do
  import Mogrify
  alias MyHive.Chat.Services.ChatMessageFileServer
  @thumbnail_size "200x150"

  def call(chat_message) do
    file_path = ChatMessageFileServer.call(chat_message)
    open(file_path)
      |> resize_to_limit(thumbnail_size())
      |> save(path: output_path(file_path, chat_message))
  end

  def output_path(path, chat_message) do
    directory_to_save(path) <> "/" <> "thumb_#{chat_message.filename}"
  end

  defp thumbnail_size() do
    @thumbnail_size
  end

  defp directory_to_save(path) when is_binary(path) do
    Path.dirname(path)
  end

  defp directory_to_save(path) when is_nil(path) do
    ""
  end
end
