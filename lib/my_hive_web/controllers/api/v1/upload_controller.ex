defmodule MyHiveWeb.Api.V1.UploadController do
  use MyHiveWeb, :controller
  use Tus.Controller
  import MyHiveWeb.Helpers.ViewHelper
  alias MyHive.FileManager
  alias MyHive.Supervisors.RadiologySupervisor
  alias MyHive.FileManager.{
    FileMetadataReader,
    FileTypeResolver,
    FileConverter,
    FileNotifier
  }

  def new(conn, %{"Upload" => upload} = params) do
    file_map = %{
      "uid" => upload["ID"],
      "size" => upload["Size"],
      "path" => params["Storage"]["Path"],
    }
    {:ok, asset} = Map.merge(file_map, upload["Metadata"])
      |> FileManager.create_asset
    post_asset_upload(file_map, asset)
    conn |> send_resp(200, "")
  end

  def on_begin_upload(_file) do
    :ok
  end

  def on_complete_upload(file) do
    file_map =  Enum.into file.metadata, %{}
    {:ok, asset} = file_map
      |> Map.put("uid", file.uid)
      |> Map.put("path", file.path)
      |> Map.put("size", file.size)
      |> FileManager.create_asset
    post_asset_upload(file_map, asset)
    :ok
  end

  def post_asset_upload(file_map, asset) do
    filetype = FileTypeResolver.call(asset.name)
    FileMetadataReader.call(asset, filetype)
    FileConverter.call(asset, asset.filetype)
    if file_map["medico_legal_case_id"] != nil do
      FileNotifier.call(asset)
      if radiology_enabled?(file_map["user_id"]) do
        RadiologySupervisor.call(asset, asset.filetype, file_map)
      end
    end
  end

  defp radiology_enabled?(user_id) do
    account_id = user_id
      |> MyHive.Accounts.get_user!()
      |> MyHive.Accounts.get_accounts_ids()
      |> List.first
    modules = account_id
      |> enabled_modules_for_account()
      |> Enum.map(fn i -> i.short_name end)
    Enum.member?(modules, "Radiology")
  end
end
