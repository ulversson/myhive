defmodule MyHiveWeb.DownloadController do
  use MyHiveWeb, :controller
  alias MyHive.{FileManager, Stats}
  alias MyHive.FileManager.{
    FileServer, FileDownloader, FileAsset
  }
  import MyHiveWeb.ControllerDecryptCommon

  def show(conn, %{"id" => asset_id, "name" => filename}) do 
    asset =  FileManager.get_file_asset!(asset_id, true)
    conn = delayed_remove(conn, asset, asset.file_encrypted)
    Stats.first_or_create(%{
      countable_id: asset_id,
      countable_type: "FileAsset",
      viewed_by: conn.assigns.current_user.id
    })
    decrypt_asset(asset, asset.file_encrypted)
    conn |> send_download({
      :file, FileServer.call(asset)},
      filename: filename,
      encode: false,
      content_type: asset.filetype,
      charset: "utf-8"
      )
  end
  
  def show(conn, %{"id" => asset_id}) do
    asset =  FileManager.get_file_asset!(asset_id, true)
    conn = delayed_remove(conn, asset, asset.file_encrypted)
    Stats.first_or_create(%{
      countable_id: asset_id,
      countable_type: "FileAsset",
      viewed_by: conn.assigns.current_user.id
    })
    decrypt_asset(asset, asset.file_encrypted)
    conn |> send_download({
      :file, FileServer.call(asset)},
      filename: FileAsset.download_name(asset),
      encode: false,
      content_type: asset.filetype,
      charset: "utf-8"
      )
  end

  def all(conn, %{"selected" => items}) do
    zip_path = FileDownloader.call(items)
    conn |> send_download(
      {:file, zip_path},
      filename: Path.basename(zip_path),
      content_type: "application/zip",
      encode: false,
      disposition: :attachment,
      charset: "utf-8"
    )
  end
end
