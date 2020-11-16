defmodule MyHiveWeb.DownloadController do
  use MyHiveWeb, :controller
  alias MyHive.{FileManager, Stats}
  alias MyHive.FileManager.{FileServer, FileDownloader}
  import MyHiveWeb.ControllerDecryptCommon

  @cleanup_after_ms 192000

  def show(conn, %{"id" => asset_id}) do
    asset =  FileManager.get_file_asset!(asset_id)
    conn = delayed_remove(conn, asset, asset.file_encrypted)
    Stats.first_or_create(%{
      countable_id: asset_id,
      countable_type: "FileAsset",
      viewed_by: conn.assigns.current_user.id
    })
    decrypt_asset(asset, asset.file_encrypted)
    conn |> send_download({
      :file, FileServer.call(asset)},
      filename: asset.name,
      encode: false,
      content_type: asset.filetype,
      charset: "utf-8"
      )
  end

  def all(conn, %{"selected" => selected}) do
    zip_path = FileDownloader.call(selected)
    conn = Plug.Conn.register_before_send(conn, fn conn ->
      TaskAfter.task_after(@cleanup_after_ms, fn ->
        dir = String.replace(zip_path, ".zip", "")
        File.rm_rf(dir)
        File.rm(zip_path)
      end)
    end)
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
