defmodule MyHive.FileManager.FolderGuardian do
  alias MyHive.{
    Repo, Accounts
  }
  alias MyHive.FileManager.Folder
  alias MyHive.Accounts.User

  def pass?(user, folder) do
    user = Repo.preload(user, [:folders, :shared_folders_by_others])
    cond do
      Accounts.is_admin_or_super_admin?(user) -> :ok
      one_of_the_owned_folders?(user, folder) -> :ok
      one_of_the_shared_with_user_folders?(user, folder) -> :ok
      one_of_the_ancestors_is_shared?(user,folder) -> :ok
      ancestor_id_present_in_shared?(user, folder) -> :ok
      is_archive?(user, folder) -> :ok
      true -> :forbid
    end
  end

  defp one_of_the_owned_folders?(user, folder) do
    ids_from_query_collection(user.folders)
    |> Enum.member?(folder.id)
  end

  defp one_of_the_shared_with_user_folders?(user, folder) do
    ids = ids_from_query_collection(user.shared_folders_by_others)
    Enum.member?(ids, folder.id)
  end

  defp one_of_the_ancestors_is_shared?(user, folder) do
    ancestors = Folder.ancestors(folder) |> Repo.all
    shared_ancestors = Enum.take_while(ancestors, fn ancestor ->
      Enum.member?(user.shared_folders_by_others, ancestor)
    end)
    length(shared_ancestors) > 0
  end

  defp ancestor_id_present_in_shared?(user, folder) do
    ancestors_ids = Folder.ancestors(folder)
      |> MyHive.Repo.all
      |> ids_from_query_collection()
    shared_ids = user.shared_folders_by_others
      |> ids_from_query_collection()
    result = ancestors_ids -- shared_ids
    length(result) > 0
  end

  defp ids_from_query_collection(collection) do
    Enum.map(collection, fn f -> f.id end)
  end

  defp is_archive?(user, folder) do
    User.is_archiver?(user) && folder.folder_type == "archive"
  end

end
