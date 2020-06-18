defmodule MyHive.Chat.Services.ChatMessageFileServer do

  def call(chat_message, outside_app \\ false) do
    if outside_app do
      storage_path() <> chat_message.path
    else
      root_with_storage() <> (chat_message.path || "")
    end
  end

  defp root_with_storage do
    File.cwd! <> "/" <> storage_path()
  end

  defp storage_path do
    Application.get_env(:tus, MyHiveWeb.Api.V1.ChatUploadController)[:base_path]
  end
end
