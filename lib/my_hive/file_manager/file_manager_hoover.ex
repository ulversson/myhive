defmodule MyHive.FileManager.FileManagerHoover do
  import MyHive.FileManager.FileManagerCommon
  alias MyHive.FileManager.Folder
  alias MyHive.FileManager.FileAsset
  alias MyHive.FileManager.FileServer
  alias MyHive.Repo

  def call(selected) do
    selected
    |> Map.values
    |> database_items
    |> Enum.each(fn item -> delete_item(item) end)
  end

  def delete_item(%Folder{} = item) do
    item = item |> Repo.preload(:file_assets)
    Repo.transaction(fn ->
      Enum.each(item.file_assets, fn item -> delete_item(item) end)
      Repo.delete(item)
    end)
  end

  def delete_item(%FileAsset{} = item) do
    Repo.delete(item)
    FileServer.call(item) |> File.rm
  end

end
