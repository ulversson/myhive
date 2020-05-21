defmodule MyHive.FileManager.AutoFileAssetUploader do

  alias MyHive.FileManager

  def call(file_path, folder, new_name) do
    Ecto.UUID.generate
      |> copy_to_destination(file_path)
      |> get_file_map(file_path, folder, new_name)
      |> FileManager.create_asset()
  end

  def get_file_map(uid, file_path, folder, new_name) do
    %{
      "filename" => new_name,
      "uid" =>  uid,
      "path" => relative_new_location(uid),
      "size" => file_size(file_path),
      "filetype" => MIME.from_path(file_path),
      "folder_id" => folder.id,
      "name" => new_name,
      "type" => MIME.from_path(file_path)
    }
  end

  def file_size(file_path) do
    case File.stat file_path do
      {:ok, %{size: size}} -> size
      {:error, reason} -> {:error, reason}
    end
  end

  def relative_base_path() do
    Application.get_env(:tus,
      MyHiveWeb.Api.V1.UploadController)[:base_path]
  end

  defp base_path() do
    Path.expand relative_base_path()
  end

  def full_path(uid) do
    base_path() <> "/" <> get_path(uid)
  end

  def relative_new_location(uid) do
    get_path(uid) <> "/" <> uid
  end

  def get_path(uid) do
    uid |> String.split("") |> Enum.slice(1, 3)  |> Path.join()
  end

  def new_location(uid) do
    full_path(uid) <> "/" <> uid
  end

  def copy_to_destination(uid, file_path) do
    uid |> full_path() |> File.mkdir_p!()
    File.cp_r(file_path, new_location(uid))
    uid
  end

end
