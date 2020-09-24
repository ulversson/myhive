defmodule MyHive.FileManager.FileAssetAllocator do

  def call(original_path, name, delete \\ true) do
    new_loc = storage_location(name)
    File.copy(original_path, new_loc)
    if delete do
      File.rm(original_path)
    end
    %{size: size} = File.stat! new_loc
    %{path: rel_path(new_loc), size: to_string(size)}
  end

  def storage_location(name) do
    uid = Ecto.UUID.generate
    storage_loc_dir = Path.join(storage_dir(), uid)
    unless File.exists?(storage_loc_dir) do
      File.mkdir_p(storage_loc_dir)
    end
    Path.join(storage_loc_dir, name)
  end

  def storage_dir do
    storage = Path.join(storage_root(), "")
    unless File.exists?(storage) do
      File.mkdir_p(storage)
    end
    storage
  end

  defp storage_root do
    Application.get_env(:tus, MyHiveWeb.Api.V1.UploadController)[:base_path]
  end

  defp rel_path(full_path) do
    String.replace(full_path, storage_root()<>"/","")
  end

end
