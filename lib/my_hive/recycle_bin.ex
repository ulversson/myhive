defmodule MyHive.RecycleBin do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.FileManager.{
    FileAsset,
    Folder
  }

  def deleted_file_assets() do
    query = from fa in FileAsset,
      where: fragment("deleted_at IS NOT NULL"),
      preload: [:folder],
      order_by: [{:desc, :deleted_at}]
    Repo.all(query)
  end

  def deleted_folders() do
    query = from fa in Folder,
      where: fragment("deleted_at IS NOT NULL"),
      order_by: [{:desc, :deleted_at}]
    Repo.all(query)
  end


end
