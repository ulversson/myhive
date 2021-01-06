
defmodule MyHive.CaseManagement.Services.MedicoLegalCaseUpdater do

  alias MyHive.{
    CaseManagement,
    Accounts,
    FileManager
  }
  alias MyHive.Repo
  alias MyHive.CaseManagement.MedicoLegalCaseNotifier
  def call(mlc, params) do
    mlc = mlc
      |> Repo.preload([patient: :addresses])
      |> Repo.preload([claimant: :addresses])
    case CaseManagement.update_medico_legal_case(mlc, params) do
      {:ok, _mlc} ->
        Repo.transaction(fn ->
          remove_users_from_case(mlc, params)
          add_users_to_case(mlc, params)
        end)
        {:ok, mlc}
      {:error, changeset} ->
        changeset
    end
  end
  def remove_users_from_case(mlc, params) do
    remove_ids = existing_ids(mlc) -- new_ids(params)
    if length(remove_ids) > 0 do
      CaseManagement.del_user_medico_legal_cases(mlc, remove_ids)
      FileManager.unshare_folder(mlc.folder_id, mlc.user_id, remove_ids)
    end
  end

  def add_users_to_case(mlc, params) do
    ids_to_add = new_ids(params)
    add_ids = ids_to_add -- existing_ids(mlc)
    Accounts.get_users_by_ids(add_ids)
      |>
      Enum.each(fn u ->
        CaseManagement.add_to_user_to_case(u, mlc)
        MedicoLegalCaseNotifier.call(u, mlc)
        FileManager.share_folder(mlc.folder_id, mlc.user_id, u.id)
    end)
  end

  defp existing_ids(mlc) do
    CaseManagement.user_ids_for_case(mlc.id)
  end

  defp new_ids(params) do
    params["user_ids"] |> Enum.map(fn x -> String.to_integer(x) end)
  end


end
