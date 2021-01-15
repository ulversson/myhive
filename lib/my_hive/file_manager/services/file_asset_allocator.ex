defmodule MyHive.FileManager.FileAssetAllocator do

  alias MyHiveWeb.Api.V1.UploadController

  def call(original_path, name, delete \\ true) do
    new_loc = storage_location(name)
    File.copy(original_path, new_loc.path)
    if delete do
      File.rm(original_path)
    end
    %{size: size} = File.stat! new_loc.path
    %{path: rel_path(new_loc.path), size: to_string(size), uid: new_loc.uid}
  end

  def storage_location(name) do
    uid = Ecto.UUID.generate
    storage_loc_dir = Path.join(storage_dir(), get_path(uid))
    unless File.exists?(storage_loc_dir) do
      File.mkdir_p(storage_loc_dir)
    end
    %{path: Path.join(storage_loc_dir, name), uid: uid}
  end

  def storage_dir do
    storage = Path.join(storage_root(), "")
    unless File.exists?(storage) do
      File.mkdir_p(storage)
    end
    storage
  end

  def get_path(uid) do
    uid
    |> String.split("")
    |> Enum.slice(1, 3)
    |> Path.join()
  end

  defp storage_root do
    Application.get_env(:tus, UploadController)[:base_path]
  end

  defp rel_path(full_path) do
    String.replace(full_path, storage_root()<>"/","")
  end

end
