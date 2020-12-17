
defmodule MyHive.CaseManagement.Services.MedicoLegalCaseGenerator do

  alias MyHive.{CaseManagement, Accounts}
  alias MyHive.{FileManager, Saas}

  alias MyHive.Repo
  alias MyHive.CaseManagement.{
    MedicoLegalCaseNotifier,
    MedicoLegalCaseReferenceGenerator
  }
  def call(params) do
    case CaseManagement.create_medico_legal_case(params) do
      {:ok, mlc} ->
        Repo.transaction(fn ->
          root = create_case_folder(mlc)
          tree = Saas.get_active_tree(mlc.account_id)
          FileManager.create_folders_from_tree(tree.json_tree, mlc.user_id, root.id)
          Accounts.get_users_by_ids(mlc.user_ids) |> add_users_to_case(mlc, root.id)
          CaseManagement.add_folder(mlc, root.id)
          MedicoLegalCaseReferenceGenerator.call(mlc, true)
          CaseManagement.add_stages_for_case(mlc.id)
        end)
        {:ok, mlc}
      {:error, changeset} ->
        changeset
    end
  end

  def create_case_folder(mlc) do
    mlc = mlc |> Repo.preload([:user, :patient])
    {:ok, folder} = FileManager.create_folder(%{
      name: "#{mlc.patient.first_name}.#{mlc.patient.last_name}",
      folder_type: "medico_legal_case_root",
      user_id: mlc.user_id
    })
    folder
  end

  defp add_users_to_case(users, mlc, case_folder_id) do
    Enum.each(users, fn user ->
      CaseManagement.add_to_user_to_case(user, mlc)
      MedicoLegalCaseNotifier.call(user, mlc)
      FileManager.share_folder(case_folder_id, mlc.user_id, user.id)
    end)
  end

end
