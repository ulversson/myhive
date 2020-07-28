defmodule MyHive.FileManager.FileServer do

  def call(file_asset) do
    cond do
      String.starts_with?(file_asset.path, "/") -> file_asset.path
      env() == :dev -> Path.join([File.cwd!, storage_root(), file_asset.path])
      true -> Path.join([storage_root(), file_asset.path])
     end
  end

  defp storage_root() do
    Application.get_env(:tus, MyHiveWeb.Api.V1.UploadController)[:base_path]
  end

  defp env do
    Application.get_env(:my_hive, :environment)
  end
end
