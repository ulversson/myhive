defmodule MyHive.Blog.Services.BlogWarehouseman do

  def call(original_path, name) do
    new_loc = storage_location(name)
    File.copy(original_path, new_loc)
    File.rm(original_path)
    %{size: size} = File.stat! new_loc
    %{path: new_loc, size: size}
  end

  def storage_root do
    Application.get_env(:my_hive, MyHiveWeb.Endpoint)[:blog_storage_root]
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
    storage = Path.join(storage_root(), "blog_files")
    unless File.exists?(storage) do
      File.mkdir_p(storage)
    end
    storage
  end
end
