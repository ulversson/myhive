defmodule MyHive.FileManager.FileServer do

  def call(file_asset) do
    storage_path() <> "/" <> file_asset.path
  end

  defp storage_path do
    Application.get_env(:tus, MyHiveWeb.Api.V1.UploadController)[:base_path]
  end
end
