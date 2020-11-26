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

  def restore_file(%FileAsset{} = file) do
    query = """
      UPDATE file_assets set deleted_at = NULL where id= '#{file.id}'
    """
    Ecto.Adapters.SQL.query!(Repo, query)
  end

  def restore_folder(%Folder{} = folder) do
    query = """
      UPDATE folders set deleted_at = NULL where id= '#{folder.id}'
    """
    Ecto.Adapters.SQL.query!(Repo, query)
    folder = Repo.preload(folder, [:file_assets])
    Enum.each(folder.file_assets, fn  file_asset ->
      restore_file(file_asset)
    end)
    assets = Folder.children(folder) |> Repo.all()
    Enum.each(assets, fn child ->
      restore_folder(child)
    end)
  end


end
