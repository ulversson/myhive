defmodule MyHive.FileManager.FileServer do

  def call(file_asset) do
    if (env() != :dev) do
      file_asset.path
    else
      Path.join([File.cwd!, file_asset.path])
    end
  end

  defp env do
    Application.get_env(:my_hive, :environment)
  end
end
