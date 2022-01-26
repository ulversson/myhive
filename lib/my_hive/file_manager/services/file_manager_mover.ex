defmodule MyHive.FileManager.FileManagerMover do
  import MyHive.FileManager.FileManagerCommon
  alias MyHive.FileManager
  alias MyHive.FileManager.{
    FileAsset, Folder
  }
  def call(selected, move_to_folder_id) do
    selected
    |> Map.values()
    |> Enum.map(fn x -> process_item(x) end)
    |> Enum.each(fn item -> move_item(item, move_to_folder_id) end)
  end

  def move_item(%FileAsset{} = asset, move_to_folder_id) do
    FileManager.move_asset(asset.id, move_to_folder_id)
  end

  def move_item(%Folder{} = folder, move_to_folder_id) do
    FileManager.move_folder(folder.id, move_to_folder_id)
  end
end
