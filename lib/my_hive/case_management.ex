defmodule MyHive.CaseManagement do

  import Ecto.Query, warn: false
  alias MyHive.Repo

  alias MyHive.CaseManagement.MedicoLegalCase

  def list_medico_legal_cases do
    Repo.all(MedicoLegalCase)
  end

  def get_medico_legal_case!(id), do: Repo.get!(MedicoLegalCase, id)

  def create_medico_legal_case(attrs \\ %{}) do
    %MedicoLegalCase{}
    |> MedicoLegalCase.changeset_assoc(attrs)
    |> Repo.insert()
  end

  def update_medico_legal_case(%MedicoLegalCase{} = medico_legal_case, attrs) do
    medico_legal_case
    |> MedicoLegalCase.changeset(attrs)
    |> Repo.update()
  end

  def delete_medico_legal_case(%MedicoLegalCase{} = medico_legal_case) do
    Repo.delete(medico_legal_case)
  end

  def change_medico_legal_case(%MedicoLegalCase{} = medico_legal_case) do
    MedicoLegalCase.changeset(medico_legal_case, %{})
  end
end
