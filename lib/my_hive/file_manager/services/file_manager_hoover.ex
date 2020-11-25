defmodule MyHive.FileManager.FileManagerHoover do
  import MyHive.FileManager.FileManagerCommon
  alias MyHive.FileManager.{Folder, FileAsset}
  alias MyHive.{
    Repo#,
    #FileManager
  }

  def call(selected) do
    selected
      |> Map.values
      |> database_items
      |> Enum.each(fn item -> delete_item(item) end)
  end

  def delete_item(%Folder{} = item) do
    item = item |> Repo.preload([:file_assets, :shared_with_users])
    Repo.transaction(fn ->
      #user_ids = Enum.map(item.shared_with_users, fn user -> user.id end)
      #FileManager.unshare_folder(item.id, item.user_id, user_ids)
      Enum.each(item.file_assets, fn item -> delete_item(item) end)
      Repo.soft_delete(item)
    end)
  end

  def delete_item(%FileAsset{} = item) do
    #FileAsset.delete_enc(item)
    Repo.soft_delete(item)
  end

end
