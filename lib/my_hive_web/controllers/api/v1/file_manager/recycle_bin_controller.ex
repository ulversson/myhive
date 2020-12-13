defmodule MyHiveWeb.Api.V1.FileManager.RecycleBinController do
  use MyHiveWeb, :controller
  alias MyHive.{
    RecycleBin, FileManager
  }
  alias MyHive.RecycleBin.{
    BinRestorer,BinGroupRestorer
  }
  alias MyHive.FileManager.FileManagerHoover
  alias MyHiveWeb.ApiFallbackController

  def index(conn, _params) do
    user_id = conn.private.guardian_default_resource.id
    assets = RecycleBin.deleted_file_assets(user_id)
    folders = RecycleBin.deleted_folders(user_id)
    conn |> render("bin.json", %{
      assets: assets,
      folders: folders,
      user_id: user_id
    })
  end

  def restore(conn, %{"id" => _id, "type" => _type} = params) do
    case BinRestorer.call(params) do
      true ->
        conn |> json(%{
          "success" => true,
          "message" => "Item restored",
          "status" => "ok"
        })
      {:error, error} ->
        ApiFallbackController.call(conn, {
          :error, error
        })
    end
  end

  def group_restore(conn, %{"selected" => selected}) do
    result = BinGroupRestorer.call(selected)
    if BinGroupRestorer.has_errors?(result) do
      ApiFallbackController.call(conn, {
        :error, :error_restore_not_all
      })
    else
      conn |> json(%{
        "success" => true,
        "message" => "Items resotred",
        "status" => "ok"
      })
    end
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

  def delete_all(conn, %{"selected" => selected}) do
    FileManagerHoover.call(selected)
    conn |> json(%{"success" => true})
  end


end
