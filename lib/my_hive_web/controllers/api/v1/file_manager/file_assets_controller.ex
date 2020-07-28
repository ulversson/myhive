defmodule MyHiveWeb.Api.V1.FileManager.FileAssetsController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  alias MyHive.FileManager.{FileManagerHoover}
  action_fallback MyHiveWeb.ApiFallbackController

  def delete(conn, %{"id" => id}) do
    FileManager.get_file_asset!(id) |> FileManagerHoover.delete_item
    conn |> json(%{"success" => true, "status" => "ok"})
  end

  def patch(conn, %{"file_asset" => file_asset_params}) do
    FileManager.get_file_asset!(file_asset_params["id"]) |> FileManager.update_file_asset(file_asset_params)
    conn |> json(%{"success" => true})
  end

end
