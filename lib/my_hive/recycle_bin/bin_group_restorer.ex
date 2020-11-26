defmodule MyHive.RecycleBin.BinGroupRestorer do

  alias MyHive.RecycleBin.BinRestorer
  alias MyHive.FileManager
  alias MyHive.FileManager.{
    FileAsset, Folder
  }

  def call(selected) do
    selected
      |> Map.values
      |> Enum.map(fn x -> get_item(x) end)
      |> process
  end

  def has_errors?(result) do
    error_tuples = Enum.filter(result, fn i -> is_tuple(i) end)
    length(error_tuples) > 0
  end

  defp process(items) do
    Enum.map(items, fn item ->
      restore_single(item)
    end)
  end

  defp restore_single(%FileAsset{} = item) do
    BinRestorer.call(%{"id" => item.id, "type" => "file"})
  end

  defp restore_single(%Folder{} = item) do
    BinRestorer.call(%{"id" => item.id, "type" => "folder"})
  end

  defp get_item(%{"checked" => "true", "id" => id, "type" => "folder"}) do
    FileManager.get_folder!(id, true)
  end

  defp get_item(%{"checked" => "true", "id" => id, "type" => "file"}) do
    FileManager.get_file_asset!(id, true)
  end
end
