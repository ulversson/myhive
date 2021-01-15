defmodule MyHive.EmailInbox.Services.OutlookFileAssetGenerator do

  alias MyHive.FileManager.{
    FileMetadataGenerator,
    FileMetadataReader,
    FileConverter,
    FileTypeResolver
  }
  alias MyHive.{
    FileManager
  }

  def call(user_id, folder_id, ms_attachment) do
    file_path = temporary_image_path(ms_attachment)
    case write_temp_file(file_path, ms_attachment) do
      :ok ->
        plug_file = %Plug.Upload{
          path: file_path,
          content_type: ms_attachment["contentBytes"],
          filename: String.replace(ms_attachment["name"],"/","_")
        }
        file_data = FileMetadataGenerator.call(%{
          "name" => ms_attachment["name"],
          "folder_id" => folder_id
        }, plug_file)
        {:ok, file_asset} = FileManager.create_asset(file_data)
        filetype = FileTypeResolver.call(file_asset.name)
        FileMetadataReader.call(file_asset, filetype)
        FileConverter.call(file_asset, file_asset.filetype)
        file_asset
    end
  end

  defp temporary_image_path(attachment) do
    "/tmp/#{Timex.now |> Timex.to_unix}#{Path.extname(attachment["name"])}"
  end

  defp write_temp_file(path, attachment) do
    base64_data = "data:#{attachment["contentType"]};base64,#{attachment["contentBytes"]}"
    {start, length} = :binary.match(base64_data, ";base64,")
    write_data = :binary.part(base64_data, start + length, byte_size(base64_data) - start - length)
    {:ok, file} = File.open(path, [:write])
    {:ok, file_string} = Base.decode64(write_data)
    IO.binwrite file, file_string
  end

end
