defmodule MyHiveWeb.Api.V1.UploadController do
  use MyHiveWeb, :controller
  use Tus.Controller
  alias MyHive.FileManager

  def on_begin_upload(_file) do
    :ok
  end

  # Completed upload optional callback
  def on_complete_upload(file) do
    file_map =  Enum.into file.metadata, %{}
    file_map
      |> Map.put("uid", file.uid)
      |> Map.put("size", file.size)
      |> FileManager.create_asset
  end
end
