defmodule MyHive.RecycleBin do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.FileManager.FileAsset


  def deleted_file_assets() do
    query = from fa in FileAsset,
      where: fragment("deleted_at IS NOT NULL"),
      preload: [:folder],
      order_by: [{:desc, :deleted_at}]
    Repo.all(query)
  end


end
