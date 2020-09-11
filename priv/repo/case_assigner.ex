defmodule MyHive.CaseAssigner do
  alias MyHive.CaseManagement
  alias MyHive.Accounts
  alias MyHive.Repo
  alias MyHive.FileManager

  def call(prof_id) do
    profs_cases = CaseManagement.cases_with_user(prof_id)
    sophie = Accounts.get_user!(42) |> Repo.preload(:shared_folders_by_others)
    anthony = Accounts.get_user!(18) |> Repo.preload(:shared_folders_by_others)
    viv = Accounts.get_user!(7) |> Repo.preload(:shared_folders_by_others)
    Enum.each(profs_cases, fn mlc ->
      if !has_shared_folder?(mlc, sophie) do
        FileManager.share_folder(mlc.folder_id, mlc.user_id, sophie.id)
      end
      if !has_shared_folder?(mlc, anthony) do
        FileManager.share_folder(mlc.folder_id, mlc.user_id, anthony.id)
      end
      if !has_shared_folder?(mlc, viv) do
        FileManager.share_folder(mlc.folder_id, mlc.user_id, viv.id)
      end
    end)
  end

  def has_shared_folder?(mlc, user) do
    folder = MyHive.FileManager.get_folder!(mlc.folder_id)
    ids = ids_from_query_collection(user.shared_folders_by_others)
    Enum.member?(ids, folder.id)
  end

  defp ids_from_query_collection(collection) do
    Enum.map(collection, fn f -> f.id end)
  end


end
MyHive.CaseAssigner.call(System.get_env("US_ID"))
