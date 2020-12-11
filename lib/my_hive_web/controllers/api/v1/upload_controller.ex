defmodule MyHiveWeb.Api.V1.UploadController do
  use MyHiveWeb, :controller
  use Tus.Controller
  import MyHiveWeb.Helpers.ViewHelper
  alias MyHive.{Accounts, FileManager}
  alias MyHive.Supervisors.RadiologySupervisor
  alias MyHive.FileManager.{
    FileMetadataReader,
    FileTypeResolver,
    FileConverter,
    FileMetadataGenerator,
    FileAssetOverwriter,
  }
  def new(conn, %{"files" => uploaded_files} = params)  do
    Enum.map(uploaded_files, fn file ->
      file_data = FileMetadataGenerator.call(params, file)
      if FileAssetOverwriter.overwrite?(params, file.filename) do
        FileAssetOverwriter.call(file_data)
      else
        {:ok, asset} = FileManager.create_asset(file_data)
        post_asset_upload(file_data, asset)
      end
    end)
    conn |> send_resp(200, "")
  end

  def mobile(conn, %{"file" => file} = params)  do
    file_data = FileMetadataGenerator.call(params, file)
    if FileAssetOverwriter.overwrite?(params, file.filename) do
      FileAssetOverwriter.call(file_data)
    else
      {:ok, asset} = FileManager.create_asset(file_data)
      post_asset_upload(file_data, asset)
    end
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
    asset = FileConverter.call(asset, asset.filetype)
    if file_map["medico_legal_case_id"] != nil do
      if radiology_enabled?(file_map["user_id"]) do
        RadiologySupervisor.call(asset, asset.filetype, file_map)
      end
    end
    asset
  end

  defp radiology_enabled?(user_id) do
    account_id = user_id
      |> Accounts.get_user!()
      |> Accounts.get_accounts_ids()
      |> List.first
    modules = account_id
      |> enabled_modules_for_account()
      |> Enum.map(fn i -> i.short_name end)
    Enum.member?(modules, "Radiology")
  end
end
