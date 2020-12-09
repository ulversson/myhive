defmodule MyHive.CaseManagement.Services.PhotoIdGenerator do

  alias MyHive.FileManager.{
    FileMetadataGenerator,
    FileMetadataReader,
    FileManagerHoover,
    FileConverter
  }
  alias MyHive.{
    Repo,
    FileManager,
    CaseManagement,
    FileManager
  }

  def call(image_data, consultation_id) do
    consultation = CaseManagement.find_consultation_by_id(consultation_id)
    remove_old_photo_ids(consultation.consultation_photo_id)
    case consultation_id
      |> temporary_image_path()
      |> write_temp_file(image_data) do
      :ok ->
        image_path =  temporary_image_path(consultation_id)
        plug_file = %Plug.Upload{
          path: image_path,
          content_type: "image/jpeg",
          filename: "#{consultation_id}-photo-id.jpg"
        }
        file_data = FileMetadataGenerator.call(%{
          "name" => "#{consultation_id}-photo-id.jpg",
          "folder_id" => List.first(consultation.folders).id
        }, plug_file)
          {:ok, file_asset} = FileManager.create_asset(file_data)
          res = CaseManagement.create_consultation_photo_id(consultation_id, file_asset)
          FileMetadataReader.call(file_asset, file_asset.filetype)
          FileConverter.call(file_asset, file_asset.filetype)
          res
    end
  end

  defp remove_old_photo_ids(consultation) when is_nil(consultation) == false do
    CaseManagement.delete_photos_for(consultation.patient_consultation_id)
    consultation.file_asset_id
      |> FileManager.get_file_asset!()
      |> FileManagerHoover.hard_delete_item()
  end

  defp remove_old_photo_ids(consultation) when is_nil(consultation) == true do
  end

  defp temporary_image_path(consultation_id) do
    "/tmp/#{consultation_id}-photo-id.jpg"
  end

  defp write_temp_file(path, image_data) do
    {start, length} = :binary.match(image_data, ";base64,")
    write_data = :binary.part(image_data, start + length, byte_size(image_data) - start - length)

    {:ok, file} = File.open(path, [:write])
    {:ok, image_string} = Base.decode64(write_data)
    IO.binwrite file, image_string
  end

end
