defmodule MyHiveWeb.Api.V1.FileManager.FoldersController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  alias MyHive.FileManager.FileManagerHoover
  alias MyHive.FileManager.FileDownloader
  action_fallback MyHiveWeb.ApiFallbackController

  def show(conn, %{"column" => column, "id" => folder_id, "order" => order}) do
    folder = FileManager.get_folder!(folder_id)
    render(conn, :show,
      folder: folder, column: column,
      order: order,
      roles: current_user(conn).roles,
      user_id: current_user(conn).id)
  end

  def create(conn, %{"parent_id" => parent_id,
    "column" => column, "order" => order, "description" => desc,
    "name" => name, "folder_type" => folder_type}) do
      {:ok, folder} = FileManager.create_folder(%{
        name: name,
        folder_type: folder_type,
        user_id: current_user(conn).id,
        description: desc,
        parent_id: parent_id})
     conn |>
      render("show.json",
        folder: folder,
        column: column,
        roles: current_user(conn).roles,
        order: order,
        user_id: current_user(conn).id)
  end

  def download(conn, %{"selected" => selected}) do
    zip_path = FileDownloader.call(selected)
    conn |> send_download(
      {:file, zip_path},
      filename: Path.basename(zip_path),
      content_type: "application/zip",
      disposition: :attachment,
      charset: "utf-8"
    )
  end

  def delete(conn, %{"id" => id}) do
    FileManager.get_folder!(id) |> FileManagerHoover.delete_item
    conn |> json(%{"success" => true})
  end

  def patch(conn, %{"folder" => folder_params}) do
    FileManager.get_folder!(folder_params["id"]) |> FileManager.update_folder(folder_params)
    conn |> json(%{"success" => true})
  end

  defp current_user(conn) do
    conn.private.guardian_default_resource
  end

end
