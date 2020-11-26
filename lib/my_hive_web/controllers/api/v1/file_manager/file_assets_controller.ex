defmodule MyHiveWeb.Api.V1.FileManager.FileAssetsController do
  use MyHiveWeb, :controller
  alias MyHive.{FileManager, Stats}
  alias MyHive.FileManager.{
    FileManagerHoover,
    FileAssetDecryptor,
    FileServer
  }
  import MyHiveWeb.ControllerDecryptCommon
  action_fallback MyHiveWeb.ApiFallbackController

  def delete(conn, %{"id" => id}) do
    user_id = conn.private.guardian_default_resource.id
    FileManager.get_file_asset!(id)
      |> FileManagerHoover.soft_delete_item(user_id)
    conn |> json(%{"success" => true, "status" => "ok"})
  end

  def patch(conn, %{"file_asset" => file_asset_params}) do
    FileManager.get_file_asset!(file_asset_params["id"])
      |> FileManager.update_file_asset(file_asset_params)
    conn |> json(%{"success" => true})
  end

  def decrypt(conn, %{"assets" => assets}) do
    for {file_asset_id, pass} <- assets do
      FileAssetDecryptor.call(file_asset_id, pass)
    end
    conn |> json(%{"success" => true})
  end

  def move(conn, %{"id" => asset_id, "folder_id" => folder_id}) do
    FileManager.move_asset(asset_id, folder_id)
    conn |> json(%{"success" => true})
  end

  def show(conn, %{"id" => asset_id}) do
    asset =  FileManager.get_file_asset!(asset_id)
    conn = delayed_remove(conn, asset, asset.file_encrypted)
    Stats.first_or_create(%{
     countable_id: asset_id,
     countable_type: "FileAsset",
     viewed_by: conn.private.guardian_default_resource.id
   })
   decrypt_asset(asset, asset.file_encrypted)
   conn
    |> put_resp_content_type(asset.filetype)
    |> put_resp_header("accept-ranges", "bytes")
    |> put_resp_header("content-length", asset.size)
    |> send_download({
      :file, FileServer.call(asset)},
      filename: asset.name,
      encode: false,
      content_type: asset.filetype,
      charset: "utf-8"
      )
    end
end
