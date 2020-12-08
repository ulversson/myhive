defmodule MyHive.CaseManagement.Services.PhotoIdGenerator do

  alias MyHive.FileManager.{
    FileMetadataGenerator
  }
  alias MyHive.{
    Repo, FileManager, CaseManagement
  }

  def call(image_data, consultation_id) do
    case consultation_id
      |> temporary_image_path()
      |> write_temp_file(image_data) do
      :ok ->
        image_path =  temporary_image_path(consultation_id)
        consultation = CaseManagement.find_consultation_by_id(consultation_id)
        plug_file = %Plug.Upload{
          path: image_path,
          content_type: "image/jpeg",
          filename: "#{consultation_id}-photo-id.jpg"
        }
        file_data = FileMetadataGenerator.call(%{
          "name" => "#{consultation_id}-photo-id.jpg",
          "folder_id" => List.first(consultation.folders).id
        }, plug_file)
        Repo.transaction(fn ->
          remove_old_photo_ids(consultation.consultation_photo_id)
          {:ok, file_asset} = FileManager.create_asset(file_data)
          CaseManagement.create_consultation_photo_id(consultation_id, file_asset)
        end)
    end
  end

  defp remove_old_photo_ids(consultation) when is_nil(consultation) == false do
    Repo.delete(consultation)
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
