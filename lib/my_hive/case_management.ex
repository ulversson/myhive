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

  def get_case_with_data(case_id) do
    Repo.get!(MedicoLegalCase, case_id)
    |> Repo.preload([:account, :users, :user])
    |> Repo.preload([patient: :addresses])
    |> Repo.preload([claimant: :addresses])
    |> Repo.preload([instructing_party: :addresses])
  end

  def update_medico_legal_case(%MedicoLegalCase{} = medico_legal_case, attrs) do
    medico_legal_case
    |> MedicoLegalCase.changeset_assoc(attrs)
    |> Repo.update()
  end

  def delete_medico_legal_case(%MedicoLegalCase{} = medico_legal_case) do
    Repo.delete(medico_legal_case)
  end

  def user_medico_legal_cases(id)  do
    from c in MyHive.CaseManagement.UserMedicoLegalCase,
    where: c.medico_legal_case_id == ^id
  end

  def del_user_medico_legal_cases(mlc, ids) do
    query = from c in MyHive.CaseManagement.UserMedicoLegalCase,
    where: c.user_id in ^ids and c.medico_legal_case_id == ^mlc.id
    Repo.delete_all(query)
  end

  def delete_user_medico_legal_cases(id) do
    id |> user_medico_legal_cases |> Repo.delete_all
  end
  def user_ids_for_case(id) do
    id
    |> user_medico_legal_cases
    |> Repo.all
    |> Enum.map(fn x -> x.user_id end)
  end

  def change_medico_legal_case(%MedicoLegalCase{} = medico_legal_case) do
    MedicoLegalCase.changeset_assoc(medico_legal_case)
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

  def add_folder(mlc, folder_id) do
    mlc
    |> Ecto.Changeset.change(%{folder_id: folder_id})
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

  def get_case_by_folder_id(folder_id) do
    Repo.get_by(MedicoLegalCase, folder_id: folder_id)
  end

  def get_case_by_folder_id(nil) do
  end


end
