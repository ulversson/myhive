
defmodule MyHive.CaseManagement.Services.MedicoLegalCaseGenerator do

  alias MyHive.CaseManagement
  alias MyHive.{FileManager, Saas}
  alias MyHive.Repo
  def call(params) do
    case CaseManagement.create_medico_legal_case(params) do
      {:ok, mlc} ->
        Repo.transaction(fn ->
          root = create_case_folder(mlc)
          tree = Saas.first_folder_tree()
          FileManager.create_folders_from_tree(tree.json_tree, mlc.user_id, root.id)
        end)
        {:ok, mlc}
      {:error, changeset} ->
        changeset
    end
  end

  def create_case_folder(mlc) do
    mlc = mlc |> Repo.preload(:user)
    {:ok, folder} = FileManager.create_folder(%{
      name: "#{mlc.patient.first_name}.#{mlc.patient.last_name}",
      folder_type: "medico_legal_case",
      user_id: mlc.user_id
    })
    folder
  end

end
