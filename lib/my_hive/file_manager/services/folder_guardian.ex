defmodule MyHive.FileManager.FolderGuardian do
  alias MyHive.{
    Repo, Accounts
  }
  alias MyHive.FileManager.Folder

  def pass?(user, folder) do
    user = Repo.preload(user, [:folders, :shared_folders_by_others])
    cond do
      Accounts.is_admin_or_super_admin?(user) -> :ok
      one_of_the_owned_folders?(user, folder) -> :ok
      one_of_the_shared_with_user_folders?(user, folder) -> :ok
      one_of_the_ancestors_is_shared?(user,folder) -> :ok
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
    ancestors = Folder.ancestors(folder) |> MyHive.Repo.all
    shared_ancestors = Enum.take_while(ancestors, fn ancestor ->
      Enum.member?(user.shared_folders_by_others, ancestor)
    end)
    length(shared_ancestors) > 0
  end

  defp ids_from_query_collection(collection) do
    Enum.map(collection, fn f -> f.id end)
  end

end
