defmodule MyHiveWeb.Api.V1.FileManager.FoldersController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  alias MyHive.TreeManager
  action_fallback MyHiveWeb.ApiFallbackController

  def show(conn, %{"column" => column, "id" => folder_id, "order" => order}) do
    folder = FileManager.get_folder!(folder_id)
    render(conn, :show, folder: folder, column: column, order: order)
  end

  def create(conn, %{"parent_id" => parent_id,
    "column" => column, "order" => order, "description" => desc,
    "name" => name, "folder_type" => folder_type}) do
      current_user = Guardian.Plug.current_resource(conn)
      {:ok, folder} = FileManager.create_folder(%{
        name: name,
        folder_type: folder_type,
        user_id: current_user.id,
        description: desc,
        parent_id: parent_id})
     conn |> render("show.json",
      folder: folder, column: column, order: order)
  end

end
