defmodule MyHiveWeb.Api.V1.FileManager.RecycleBinController do
  use MyHiveWeb, :controller
  alias MyHive.{
    RecycleBin, FileManager, CaseManagement
  }
  alias MyHive.FileManager.FileManagerHoover

  def index(conn, _params) do
    user_id = conn.private.guardian_default_resource.id
    assets = RecycleBin.deleted_file_assets
    folders = RecycleBin.deleted_folders
    conn |> render("bin.json", %{
      assets: assets,
      folders: folders,
      user_id: user_id
    })
  end

  def restore(conn, %{"id" => id, "type" => "file"}) do
    user_id = conn.private.guardian_default_resource.id
    asset =  FileManager.get_file_asset!(id, true)
    restore_file(conn, asset)
  end

  def restore(conn, %{"id" => id, "type" => "folder"}) do
    user_id = conn.private.guardian_default_resource.id
    folder = FileManager.get_folder!(id, true)
    restore_folder(conn, folder, folder_type(folder))
  end

  def delete(conn, %{"id" => id, "type" => "file"}) do
    asset = FileManager.get_file_asset!(id, true)
    FileManagerHoover.hard_delete_item(asset)
    conn |> json(%{
      "success" => true,
      "message" => "File #{asset.name} deleted",
      "status" => "ok"
    })
  end

  def delete(conn, %{"id" => id, "type" => "folder"}) do
    folder = FileManager.get_folder!(id, true)
    FileManagerHoover.hard_delete_item(folder)
    conn |> json(%{
      "success" => true,
      "message" => "File #{folder.name} deleted",
      "status" => "ok"
    })
  end

  defp restore_file(conn, asset) when is_nil(asset) == false do
    folder = FileManager.get_folder!(asset.folder_id)
    if is_nil(folder) do
      MyHiveWeb.ApiFallbackController.call(conn, {
        :error, :restore_folder_not_found
      })
    else
      RecycleBin.restore_file(asset)
      conn |> json(%{
        "success" => true,
        "message" => "File #{asset.name} restored",
        "status" => "ok"
      })
    end
  end

  defp restore_file(conn, asset) when is_nil(asset) == true do
    MyHiveWeb.ApiFallbackController.call(conn, {
      :error, :restore_folder_not_found
    })
  end

  defp restore_folder(conn, folder, folder_type)
    when folder_type == "medico_legal_case" or folder_type == "medico_legal_case_admin" or folder_type == "medico_legal_case_correspondence" do
      root = FileManager.root_for(folder.id)
      restore_case_folder(conn, folder, root)
  end

  defp restore_folder(conn, folder, folder_type) when folder_type == "shared_folder" or folder_type == "archive" do
    root = FileManager.root_for(folder.id)
    restore_non_case_folder(conn, folder, root)
  end

  defp restore_folder(conn, _, _) do
    MyHiveWeb.ApiFallbackController.call(conn, {
      :error, :restore_error_no_root
    })
  end

  defp restore_case_folder(conn, folder, root)  when is_nil(root) == false do
    mlc = CaseManagement.get_case_by_folder_id(root.id)
    if is_nil(mlc) do
      MyHiveWeb.ApiFallbackController.call(conn, {
        :error, :restore_error_with_case
      })
    else
      successful_restore(conn, folder)
    end
  end

  defp restore_case_folder(conn, folder, root) when is_nil(root) == true do
    MyHiveWeb.ApiFallbackController.call(conn, {
      :error, :restore_error_with_case
    })
  end

  defp restore_non_case_folder(conn, folder, root) when is_nil(root) == false do
    successful_restore(conn, folder)
  end

  defp restore_non_case_folder(conn, folder, root) when is_nil(root) == true do
    if is_nil(folder.parent_id) do
      successful_restore(conn, folder)
    else
      MyHiveWeb.ApiFallbackController.call(conn, {
        :error, :restore_error_no_root
      })
    end
  end

  defp successful_restore(conn, folder) do
    RecycleBin.restore_folder(folder)
    conn |> json(%{
      "success" => true,
      "status" => "ok",
      "message" => "Folder #{folder.name} restored"
    })
  end

  defp folder_type(folder) when is_nil(folder) do
    nil
  end

  defp folder_type(folder) when is_map(folder) do
    folder.folder_type
  end


end
