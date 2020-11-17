defmodule MyHiveWeb.Api.V1.FileManager.TimestampController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  action_fallback MyHiveWeb.ApiFallbackController

  def patch(conn, %{"id" => id, "type" => "file", "date" => date}) do
    asset =  FileManager.get_file_asset!(id)
    FileManager.update_file_asset_ts(asset, date)
    conn |> json(%{
      success: true
    })
  end

  def patch(conn, %{"id" => id, "type" => "folder", "date" => date}) do
    folder = FileManager.get_folder!(id)
    FileManager.update_folder_ts(folder, date)
    conn |> json(%{
      success: true
    })
  end
end
