defmodule MyHive.FileManager.FileManagerHoover do
  import MyHive.FileManager.FileManagerCommon
  alias MyHive.FileManager.{Folder, FileAsset}
  alias MyHive.{
    Repo,
    FileManager
  }

  def call(selected) do
    selected
      |> Map.values
      |> Enum.map(fn x -> get_item(x) end)
      |> Enum.each(fn item -> hard_delete_item(item) end)
  end

  def soft_call(selected) do
    selected
      |> Map.values
      |> database_items
      |> Enum.each(fn item -> soft_delete_item(item) end)
  end

  def hard_delete_item(%Folder{} = item) do
    item = item |> Repo.preload([:file_assets, :shared_with_users])
    Repo.transaction(fn ->
      user_ids = Enum.map(item.shared_with_users, fn user -> user.id end)
      FileManager.unshare_folder(item.id, item.user_id, user_ids)
      Enum.each(item.file_assets, fn item -> hard_delete_item(item) end)
      Repo.delete(item)
    end)
  end

  def hard_delete_item(%FileAsset{} = item) do
    FileAsset.delete_enc(item)
    Repo.delete(item)
  end

  def soft_delete_item(%Folder{} = item) do
    item = item |> Repo.preload([:file_assets, :shared_with_users])
    Repo.transaction(fn ->
      Enum.each(item.file_assets, fn item -> soft_delete_item(item) end)
      Repo.soft_delete(item)
    end)
  end

  def soft_delete_item(%FileAsset{} = item) do
    Repo.soft_delete(item)
  end


  defp get_item(%{"checked" => "true", "id" => id, "type" => "folder"}) do
    FileManager.get_folder!(id, true)
  end

  defp get_item(%{"checked" => "true", "id" => id, "type" => "file"}) do
    FileManager.get_file_asset!(id, true)
  end

end
