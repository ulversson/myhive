defmodule MyHive.FileManager.SharedFolderUpdater do
  alias MyHive.{
    FileManager,
    Repo
  }

  def call(folder_params, trackable) when is_boolean(trackable) do
    folder = folder_params["id"] |> get_folder()
    Repo.transaction(fn ->
      if trackable do
        shared_ids = Enum.map(folder.shared_with_users, fn user -> user.id end)
        FileManager.unshare_folder(folder.id, folder.user_id, shared_ids)
        FileManager.share_and_track(folder.id)
        FileManager.update_folder(folder, folder_params)
      end
    end)
  end

  def call(folder_params, user_ids) do
    folder = folder_params["id"] |> get_folder()
    Repo.transaction(fn ->
      remove_users_from_shared_folder(folder, user_ids)
      add_users_to_shared_folder(folder, user_ids)
      FileManager.update_folder(folder, folder_params)
    end)
  end

  def unshare(folder, user_ids) do
    FileManager.unshare_folder(folder.id, folder.user_id, user_ids)
  end

  def remove_users_from_shared_folder(folder, user_ids) do
    remove_ids = existing_ids(folder) -- new_ids(user_ids)
    if length(remove_ids) > 0 do
      FileManager.unshare_folder(folder.id, folder.user_id, remove_ids)
    end
  end

  def add_users_to_shared_folder(folder, ids) do
    ids_to_add = new_ids(ids)
    add_ids = ids_to_add -- existing_ids(folder)
    Enum.each(add_ids, fn shared_user_id ->
      FileManager.share_folder(folder.id, folder.user_id, shared_user_id)
    end)
  end

  defp get_folder(id) do
    id |> FileManager.get_folder!() |> Repo.preload(:shared_with_users)
  end

  defp existing_ids(folder) do
    Enum.map(folder.shared_with_users, fn user ->
      user.id
    end)
  end

  defp new_ids(ids) do
    ids |> Enum.map(fn x -> String.to_integer(x) end)
  end


end
