defmodule MyHive.FileManager.FileManagerLabeler do
  import MyHive.FileManager.FileManagerCommon
  import Ecto.Query

  alias MyHive.FileManager.{FileAsset, Folder}
  alias MyHive.{Repo, Stats}
  alias MyHive.Stats.ViewCounter

  def call(selected, marking, user_id) do
    selected
    |> selected_database_items
    |> Enum.each(fn
      item -> mark_item(item, marking, user_id)
    end)
  end

  defp mark_item(item, marking, user_id) do
    case marking do
      "new" -> mark_as_new(item)
      "viewed" -> mark_as_viewed(item, user_id)
    end
  end

  defp mark_as_new(%FileAsset{} = item) do
    query = from vc in ViewCounter
    Stats.for_asset(query, item.id) |> Repo.delete_all()
  end

  defp mark_as_new(%Folder{} = item) do
    item = Repo.preload(item, :file_assets)
    Enum.each(item.file_assets, fn asset -> mark_as_new(asset) end)
    children = Folder.children(item) |> Repo.all
    Enum.each(children, fn child -> mark_as_new(child) end)
  end

  defp mark_as_viewed(%FileAsset{} = item, user_id) do
    Stats.add_view_count(%{
      viewed_by: user_id,
      countable_id: item.id,
      countable_type: "FileAsset"
    })
  end

  defp mark_as_viewed(%Folder{} = item, user_id) do
    item = Repo.preload(item, :file_assets)
    Enum.each(item.file_assets, fn asset ->
      mark_as_viewed(asset, user_id)
    end)
    children = Folder.children(item) |> Repo.all
    Enum.each(children, fn child ->
      mark_as_viewed(child, user_id)
    end)
  end

  defp selected_database_items(selected) do
    selected |> Map.values |> database_items
  end
end
