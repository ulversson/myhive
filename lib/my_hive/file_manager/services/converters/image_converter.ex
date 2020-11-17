defmodule MyHive.FileManager.Services.ImageConverter do

  alias MyHive.FileManager
  alias MyHive.Encryption.FileAssetEncryptionProcessor
  alias MyHive.FileManager.{
    FileMetadataReader,
    FileTypeResolver,
    FileServer
  }
  import MyHive.FileManager.Services.ConvertersCommon

  def call(asset, image_type) when image_type == "image/heic" or image_type == "image/heif" do
    input_path = FileServer.call(asset)
    FileManager.update_file_asset(asset, %{name: "...converting...please wait..."})
    Rambo.run(heif_convert(), heif_convert_params(input_path))
    changes = %{
      filetype: "image/jpeg",
      path: relative_path(input_path),
      name: heif_name(asset),
      uid: "#{asset.uid}",
      size: to_string(File.stat!(heif_path(input_path)).size)
    }
     {:ok, asset} = FileManager.change_to_converted_asset(asset, changes)
     filetype = FileTypeResolver.call(asset.name)
     FileMetadataReader.call(asset, filetype)
     FileAssetEncryptionProcessor.call(asset)
     File.rm(input_path)
     asset
  end

  def heif_convert_params(input_path) do
    [
      input_path,
      heif_path(input_path)
    ]
  end

  defp heif_convert() do
    "heif-convert"
  end

  defp heif_name(asset) do
    out = asset.name
     |> String.replace("heif", "jpg")
     |> String.replace("heic", "jpg")
     |> String.replace("HEIC", "jpg")
     |> String.replace("HEIF", "jpg")
     "converted_#{out}"
  end

  def relative_path(input_path) do
    path = heif_path(input_path)
    new_path = String.replace(path, File.cwd!, "")
      |> String.replace(storage_root(), "")
      |> String.replace("//","")
      if String.starts_with?(new_path, "/") do
        String.slice(new_path, 1..-1)
      else
        new_path
      end
   end

  def heif_path(input_path) do
    String.replace(input_path, "heif", "jpg") |> String.replace("heic", "jpg")
  end
end
