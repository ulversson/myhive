defmodule MyHiveWeb.Api.V1.FileManager.FoldersController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  action_fallback MyHiveWeb.ApiFallbackController

  def show(conn, %{"id" => folder_id}) do
    folder = FileManager.get_folder!(folder_id)
    render(conn, :show, folder: folder)
  end

end
