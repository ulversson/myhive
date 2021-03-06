defmodule MyHiveWeb.Api.V1.FileManager.FoldersController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  alias MyHive.FileManager.{
    FileManagerHoover,
    FileDownloader,
    SharedFolderUpdater,
    Folder
  }
  action_fallback MyHiveWeb.ApiFallbackController
  plug MyHiveWeb.Plugs.FolderGuardianPlug, "id" when action in [:show, :delete]
  plug MyHiveWeb.Plugs.AuthorizationPlug, [:archiver] when action in [:archive]


  def show(conn, %{"column" => column, "id" => folder_id, "order" => order}) do
    folder = FileManager.get_folder!(folder_id)
    render(conn, :show,
      folder: folder, column: column,
      order: order,
      roles: current_user(conn).roles,
      user_id: current_user(conn).id)
  end

  def show_tree(conn, %{"column" => column, "id" => folder_id, "order" => order}) do
    folder = FileManager.get_folder!(folder_id)
    render(conn, :show_tree,
      folder: folder, column: column,
      order: order,
      roles: current_user(conn).roles,
      user_id: current_user(conn).id)
  end

  def archive(conn, %{"column" => column, "order" => order}) do
    case FileManager.get_archive_root() do
      nil ->
        conn |> json([])
      folder ->
        render(conn, :show,
          folder: folder, column: column,
          order: order,
          roles: current_user(conn).roles,
          user_id: current_user(conn).id)
    end
  end


  def shared(conn, %{"column" => _column, "order" => _order}) do
    user = current_user(conn)
    shared_by_me_folders = FileManager.get_shared_roots(user.id)
    shared_by_others = FileManager.shared_by_others_for(user.id)
    render(conn, "index.json", %{
      shared_by_me_folders: shared_by_me_folders,
      shared_by_others_folders: shared_by_others,
      role: user.roles
    })
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

  def create(conn, %{"folder" => folder_params,
    "user_ids" => user_ids}) do
    user_id = current_user(conn).id
    {:ok, folder} = FileManager.create_folder(%{
      name: folder_params["name"],
      folder_type: "shared_folder",
      user_id: user_id,
      user_shared_root: true,
      description: folder_params["description"],
      parent_id: folder_params["parent_id"]})
      Enum.each(user_ids, fn shared_user_id ->
        FileManager.share_folder(folder.id, folder.user_id, shared_user_id)
      end)
    conn |>
      render("show.json",
        folder: folder,
        column: "name",
        roles: current_user(conn).roles,
        order: "asc",
        user_id: user_id)
  end

  def create(conn, %{"folder" => folder_params}) do
    user_id = current_user(conn).id
    {:ok, folder} = FileManager.create_folder(%{
        name: folder_params["name"],
        folder_type: "shared_folder",
        user_id: user_id,
        user_shared_root: true,
        trackable: folder_params["trackable"],
        description: folder_params["description"],
        parent_id: folder_params["parent_id"]
      })
      FileManager.share_and_track(folder.id)
    conn |>
      render("show.json",
        folder: folder,
        column: "name",
        roles: current_user(conn).roles,
        order: "asc",
        user_id: user_id)
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

  def move_tree(conn, %{"folder_id" => folder_id}) do
    case FileManager.root_for(folder_id) do
      root_folder ->
        conn |> render("move_tree.json", folder: root_folder)
    end
  end

  def move(conn, %{"id" => id, "folder_id" => folder_id}) do
    FileManager.move_folder(id, folder_id)
    conn |> json(%{"success" => true})
  end

  def ancestor(conn, %{"id" => id}) do
    folder = FileManager.get_folder!(id)
    conn |> json(%{
      parent: folder.parent_id,
      name: Folder.parent_name(folder)
    })
  end

  def delete(conn, %{"id" => id}) do
    FileManager.get_folder!(id) |> FileManagerHoover.delete_item
    conn |> json(%{
      "success" => true,
      "status" => "ok",
      message: "Folder has been removed"
    })
  end

  def patch(conn, %{"folder" => folder_params,
    "user_ids" => user_ids}) when is_list(user_ids) do
    SharedFolderUpdater.call(folder_params, user_ids)
    conn |> json(%{"success" => true, "status" => "ok"})
  end

  def patch(conn, %{"folder" => %{"trackable" => trackable} = folder_params, "id" => _id}) when is_binary(trackable) do
    SharedFolderUpdater.call(folder_params, (trackable === "true"))
    conn |> json(%{"success" => true, "status" => "ok"})
  end

  def patch(conn, %{"folder" => folder_params, "id" => id}) do
    FileManager.get_folder!(id)
      |> FileManager.update_folder(folder_params)
    conn |> json(%{"success" => true})
  end

  defp current_user(conn) do
    conn.private.guardian_default_resource
  end

end
