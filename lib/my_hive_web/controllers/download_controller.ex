defmodule MyHiveWeb.DownloadController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  alias MyHive.FileManager.FileServer
  alias MyHive.FileManager.FileDownloader

  def show(conn, %{"id" => asset_id}) do
   asset =  FileManager.get_file_asset!(asset_id)
   conn |> send_download(
      {:file, FileServer.call(asset)},
      filename: asset.name,
      content_type: asset.filetype,
      charset: "utf-8"
    )
  end

  def all(conn, %{"selected" => selected}) do
    zip_path = FileDownloader.call(selected)
    conn |> send_download(
      {:file, zip_path},
      filename: Path.basename(zip_path),
      content_type: "application/zip",
      disposition: :attachment,
      charset: "utf-8"
    )
  end
end
