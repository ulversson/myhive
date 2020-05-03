defmodule MyHive.FileManager.FileServer do

  def call(file_asset, outside_app \\ false) do
    if outside_app do
      storage_path() <> file_asset.path
    else
      root_with_storage() <> file_asset.path
    end
  end

  defp root_with_storage do
    File.cwd! <> "/" <> storage_path()
  end

  defp storage_path do
    Application.get_env(:tus, MyHiveWeb.Api.V1.UploadController)[:base_path]
  end
end
