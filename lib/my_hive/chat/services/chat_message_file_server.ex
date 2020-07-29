defmodule MyHive.Chat.Services.ChatMessageFileServer do

  def call(chat_message) do
    cond do
      String.starts_with?(chat_message.path, "/") -> chat_message.path
      env() == :dev -> Path.join([File.cwd!, storage_root(), chat_message.path])
      true -> Path.join([storage_root(), chat_message.path])
     end
  end

  defp storage_root do
    Application.get_env(:tus, MyHiveWeb.Api.V1.ChatUploadController)[:base_path]
  end

  defp env do
    Application.get_env(:my_hive, :environment)
  end
end
