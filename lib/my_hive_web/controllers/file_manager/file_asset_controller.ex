defmodule MyHiveWeb.FileManager.FileAssetController do
  use MyHiveWeb, :controller
  alias MyHive.{FileManager, Stats, Chat}
  alias MyHive.FileManager.{FileServer}
  alias MyHive.Chat.Services.{
    ChatMessageFileServer,
    ChatImageThumbnailer
  }
  import MyHiveWeb.ControllerDecryptCommon

  def show(conn, %{"id" => id}) do
    asset = FileManager.get_file_asset!(id)
    conn = delayed_remove(conn, asset, asset.file_encrypted)
    Stats.first_or_create(%{
      countable_id: id,
      countable_type: "FileAsset",
      viewed_by: conn.assigns.current_user.id
    })
    decrypt_asset(asset, asset.file_encrypted)
    conn
      |> put_resp_content_type(asset.filetype)
      |> put_resp_header("accept-ranges", "bytes")
      |> send_download(
        {:file, FileServer.call(asset)},
          filename: asset.name,
          encode: false,
          content_type: asset.filetype,
          disposition: :inline,
          charset: "utf-8"
      )
  end

  def attachment(conn, %{"message_id" => id, "thumb" => "false"}) do
    chat_message = Chat.get_message!(id)
    conn |> send_download(
      {:file, ChatMessageFileServer.call(chat_message)},
      filename: chat_message.filename,
      content_type: chat_message.filetype,
      encode: false,
      disposition: :inline,
      charset: "utf-8"
    )
  end

  def attachment(conn, %{"message_id" => id, "thumb" => "true"}) do
    chat_message = Chat.get_message!(id)
    full_path = ChatMessageFileServer.call(chat_message)
    conn |> send_download(
      {:file, ChatImageThumbnailer.output_path(full_path, chat_message)},
      filename: chat_message.filename,
      content_type: chat_message.filetype,
      encode: false,
      disposition: :inline,
      charset: "utf-8"
    )
  end

end
