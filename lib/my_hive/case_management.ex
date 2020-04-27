defmodule MyHive.CaseManagement do

  import Ecto.Query, warn: false
  alias MyHive.Repo

  alias MyHive.CaseManagement.MedicoLegalCase

  def list_medico_legal_cases do
    Repo.all(MedicoLegalCase)
  end

  def cases_with_users_and_patient() do
    Repo.all(MedicoLegalCase)
    |> Repo.preload([:users, :patient])
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

  def add_to_user_to_case(user, mlc) do
    mlc = Repo.preload(mlc,:users)
    user = Repo.preload(user, :medico_legal_cases)
    changeset = Ecto.Changeset.change(user)
    |> Ecto.Changeset.put_assoc(:medico_legal_cases, user.medico_legal_cases ++ [mlc])
    Repo.update!(changeset)
  end

  def change_status(mlc, status) do
    mlc
    |> Ecto.Changeset.change(%{status: status})
    |> status_field(status)
    |> Repo.update()
  end

  defp status_field(mlc, status) do
    case status do
      "current" ->
        Ecto.Changeset.change(mlc, %{started_at: DateTime.truncate(Timex.now, :second)})
      "settled" ->
        Ecto.Changeset.change(mlc, %{settled_at: DateTime.truncate(Timex.now, :second)})
    end
  end


end
