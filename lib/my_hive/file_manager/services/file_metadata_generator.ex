defmodule MyHive.FileManager.FileMetadataGenerator do
  alias MyHive.FileManager.{
    FileAssetAllocator,
    EncryptionChecker
  }

  def call(upload_params, plug_file) do
    file_map = FileAssetAllocator.call(plug_file.path, plug_file.filename)
    meta = Map.delete(upload_params, "files")
    file_data = Map.from_struct(plug_file)
      |> Map.merge(file_map)
      |> Map.merge(meta)

      file_data = for {key, val} <- file_data, into: %{} do
        if is_binary(key) do
          {key,val}
        else
          {to_string(key), val}
        end
      end
    file_data = Map.put(file_data, "filetype", file_data["content_type"])
    Map.put(file_data, "encrypted", EncryptionChecker.call(file_data, file_data["content_type"]))
  end

end
