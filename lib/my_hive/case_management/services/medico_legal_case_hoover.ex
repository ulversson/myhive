
defmodule MyHive.CaseManagement.Services.MedicoLegalCaseHoover do

  alias MyHive.{CaseManagement, FileManager}
  alias MyHive.Repo

  def call(medico_legal_case_id) do
    Repo.transaction(fn ->
      medico_legal_case = CaseManagement.get_medico_legal_case!(medico_legal_case_id)
      CaseManagement.delete_medico_legal_case(medico_legal_case)
      CaseManagement.delete_user_medico_legal_cases(medico_legal_case_id)
      FileManager.delete_tree(medico_legal_case.folder_id)
    end)
  end
end
