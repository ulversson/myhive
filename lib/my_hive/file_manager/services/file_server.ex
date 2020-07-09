defmodule MyHive.FileManager.FileServer do

  def call(file_asset) do
    root_with_storage() <> file_asset.path
  end

  defp root_with_storage do
    File.cwd! <> "/" <> storage_path()
  end

  defp storage_path do
    Application.get_env(:tus, MyHiveWeb.Api.V1.UploadController)[:base_path]
  end
end
