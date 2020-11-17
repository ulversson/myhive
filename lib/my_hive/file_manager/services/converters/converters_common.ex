defmodule MyHive.FileManager.Services.ConvertersCommon do

  def storage_root() do
    Application.get_env(:tus, MyHiveWeb.Api.V1.UploadController)[:base_path]
  end

end
