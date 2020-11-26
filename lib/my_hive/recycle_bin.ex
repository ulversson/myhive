defmodule MyHive.RecycleBin do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.FileManager.{
    FileAsset,
    Folder
  }

  def deleted_file_assets(user_id) do
    query = from fa in FileAsset,
      where: fragment("deleted_at IS NOT NULL"),
      preload: [:folder],
      where: fa.deleted_by == ^user_id,
      order_by: [{:desc, :deleted_at}]
    Repo.all(query)
  end

  def deleted_folders(user_id) do
    query = from f in Folder,
      where: fragment("deleted_at IS NOT NULL"),
      where: f.deleted_by == ^user_id,
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

  def items_due_to_be_removed() do
    %{
      files: files_due_to_be_removed(),
      folders: folders_due_to_be_removed()
    }
  end

  def folders_due_to_be_removed() do
    query = from f in Folder,
    where: fragment("deleted_at IS NOT NULL"),
    order_by: [{:desc, :deleted_at}],
    where: fragment("?::date", f.deleted_at) >= ^twenty_eight_days_from_now()
    Repo.all(query)
  end

  def files_due_to_be_removed() do
    query = from fa in FileAsset,
      where: fragment("deleted_at IS NOT NULL"),
      order_by: [{:desc, :deleted_at}],
      where: fragment("?::date", fa.deleted_at) >= ^twenty_eight_days_from_now()
    Repo.all(query)
  end

  defp twenty_eight_days_from_now() do
    Timex.today |> Timex.shift(days: 28)
  end


end
