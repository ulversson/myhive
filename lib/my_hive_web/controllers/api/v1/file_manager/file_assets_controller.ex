defmodule MyHiveWeb.Api.V1.FileManager.FileAssetsController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  alias MyHive.FileManager.FileManagerHoover
  action_fallback MyHiveWeb.ApiFallbackController

  def delete(conn, %{"id" => id}) do
    FileManager.get_file_asset!(id) |> FileManagerHoover.delete_item
    conn |> json(%{"success" => true})
  end

end
