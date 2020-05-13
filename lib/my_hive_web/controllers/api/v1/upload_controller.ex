defmodule MyHiveWeb.Api.V1.UploadController do
  use MyHiveWeb, :controller
  use Tus.Controller
  alias MyHive.FileManager
  alias MyHive.FileManager.{
    FileMetadataReader,
    FileTypeResolver,
    FileConverter,
    FileNotifier
  }
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
    filetype = FileTypeResolver.call(asset.name)
    FileMetadataReader.call(asset, filetype)
    FileConverter.call(asset, asset.filetype)
    FileNotifier.call(asset)
  end
end
