defmodule MyHive.CaseManagement do

  import Ecto.Query, warn: false
  alias MyHive.{
    Repo, FileManager
  }
  alias MyHive.CaseManagement.{
    MedicoLegalCase,
    InstructingParty,
    UserMedicoLegalCase,
    PatientConsultation
  }
  alias MyHive.FileManager.Folder

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

  def create_instructing_party(attrs \\ %{}) do
    %InstructingParty{}
    |> InstructingParty.changeset(attrs)
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

  def update_case(%MedicoLegalCase{} = medico_legal_case, attrs) do
    medico_legal_case
    |> Ecto.Changeset.change(attrs)
    |> Repo.update()
  end

  def delete_medico_legal_case(%MedicoLegalCase{} = medico_legal_case) do
    Repo.delete(medico_legal_case)
  end

  def user_medico_legal_cases(id)  do
    from c in UserMedicoLegalCase,
    where: c.medico_legal_case_id == ^id
  end

  def del_user_medico_legal_cases(mlc, ids) do
    query = from c in UserMedicoLegalCase,
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

  def update_created_date(mlc, created_date) do
    Ecto.Changeset.change(mlc, %{inserted_at: created_date})
    |> Ecto.Changeset.force_change(:inserted_at, created_date)
    |> Repo.update()
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
      "pending" ->
        Ecto.Changeset.change(mlc, %{})
      "current" ->
        Ecto.Changeset.change(mlc, %{started_at: DateTime.truncate(Timex.now, :second)})
      "settled" ->
        Ecto.Changeset.change(mlc, %{settled_at: DateTime.truncate(Timex.now, :second)})
    end
  end

  def get_case_by_folder_id(folder_id) do
    Repo.get_by(MedicoLegalCase, folder_id: folder_id)
  end

  def tidy_up_folders(mlc_id) do
    mlc = mlc_id
      |> get_medico_legal_case!()
    descendants = mlc.folder_id
      |> FileManager.get_folder!()
      |> Repo.preload(:file_assets)
      |> FileManager.Folder.descendants()
      |> Repo.all()
    Enum.each(descendants, fn folder ->
      folder = folder |> Repo.preload(:file_assets)
      children = Folder.children(folder) |> Repo.all()
      if length(folder.file_assets) == 0
        and folder.folder_type == "medico_legal_case"
        and length(children) === 0 do
        Repo.delete(folder)
      end
    end)
  end

  def medico_legal_cases_due() do
    query = from c in MedicoLegalCase,
    where: is_nil(c.due_date) == false,
    preload: [:users],
    where: c.due_date == ^week_from_now() or
      c.due_date == ^two_weeks_from_now() or
      c.due_date == ^three_weeks_from_now()
    Repo.all(query)
  end

  defp week_from_now() do
    Timex.today |> Timex.shift(days: 7)
  end

  defp two_weeks_from_now() do
    Timex.today |> Timex.shift(days: 14)
  end

  defp three_weeks_from_now() do
    Timex.today |> Timex.shift(days: 21)
  end

  def cases_with_user(user_id) do
    query = from mlc in MedicoLegalCase,
      join: umlc in assoc(mlc, :user_medico_legal_cases),
      join: u in assoc(mlc, :users),
      preload: [:users],
      where: umlc.user_id == ^user_id
    Repo.all(group_by(query, [mlc], mlc.id))
  end

  def create_consultation(attrs \\ %{}) do
    %PatientConsultation{}
      |> PatientConsultation.changeset(attrs)
      |> Repo.insert()
  end

end
