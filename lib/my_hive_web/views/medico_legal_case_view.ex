defmodule MyHiveWeb.MedicoLegalCaseView do
  use MyHiveWeb, :view
  alias MyHiveWeb.MedicoLegalCaseView
  alias MyHive.Accounts.User
  alias MyHive.Accounts

  def render("422.json", %{changeset: changeset}) do
    Ecto.Changeset.traverse_errors(changeset, fn
      {msg, opts} -> String.replace(msg, "%{count}", to_string(opts[:count]))
      msg -> msg
    end)
  end

  def render("index.json", %{medico_legal_cases: medico_legal_cases,
    page_number: page_number,
    page_size: page_size,
    total_entries: total_entries,
    role: role,
    total_pages: total_pages}) do
    %{data:
      render_many(medico_legal_cases, MedicoLegalCaseView, "medico_legal_case.json"),
      page: page_number,
      limit: page_size,
      role: role,
      count: total_entries,
      pages: total_pages
    }
  end

  def render("show.json", %{medico_legal_case: medico_legal_case}) do
    %{data: render_one(medico_legal_case, MedicoLegalCaseView, "case_details.json")}
  end

  def render("case_details.json", %{medico_legal_case: medico_legal_case}) do
    %{id: medico_legal_case.id,
      folder_id: medico_legal_case.folder_id,
      created_at: medico_legal_case.inserted_at,
      instructed_by: medico_legal_case.instructed_by,
      status: medico_legal_case.status,
      joint_instruction: medico_legal_case.joint_instruction,
      file_reference: medico_legal_case.file_reference,
      due_date: medico_legal_case.due_date,
      note: medico_legal_case.note,
      notifications_disabled: medico_legal_case.notifications_disabled
    }
    |> Map.put(:patient, render_one(medico_legal_case.patient,
    MyHiveWeb.ContactBook.CasePersonView, "case_person.json", as: :case_person))
    |> Map.put(:claimant, render_one(medico_legal_case.claimant,
    MyHiveWeb.ContactBook.CasePersonView, "case_person.json", as: :case_person))
    |> Map.put(:instructing_party, render_one(medico_legal_case.instructing_party,
    MyHiveWeb.CaseManagement.InstructingPartyView, "instructing_party.json", as: :instructing_party))
    |> Map.put(:user,
    render_one(medico_legal_case.user, MyHiveWeb.UserView, "user.json", as: :user))
    |> Map.put(:users,
    render_many(medico_legal_case.users, MyHiveWeb.UserView, "user.json", as: :user))
  end

  def render("medico_legal_case.json", %{medico_legal_case: medico_legal_case}) do
    %{
      id: medico_legal_case.id,
      user_id: medico_legal_case.user_id,
      folder_id: medico_legal_case.folder_id,
      joint_instruction: medico_legal_case.joint_instruction,
      account_id: medico_legal_case.account_id,
      owner: User.name_for(medico_legal_case.user),
      users: get_users(medico_legal_case),
      file_reference: medico_legal_case.file_reference,
      created_at: medico_legal_case.inserted_at,
      patient: patient_name(medico_legal_case),
      deceased: medico_legal_case.patient.deceased,
      status: medico_legal_case.status,
      due_date: medico_legal_case.due_date,
      note: medico_legal_case.note,
      notifications_disabled: medico_legal_case.notifications_disabled
    }
  end

  def render("statuses.json", %{statuses: statuses}) do
    %{
      data: Enum.map(statuses, fn stat ->  status_json(stat) end),
      started: (statuses |> started_collection() |> Enum.map(fn stat ->  status_json(stat) end)),
      completed: (statuses |> completed_collection() |> Enum.map(fn stat ->  status_json(stat) end))
    }
  end

  def render("status.json", %{status: status}) do
    status_json(status)
  end


  def status_json(stat) do
    %{
      id: stat.id,
      name: stat.name,
      icon: stat.medico_legal_case_progress_state.icon,
      order: stat.order,
      completed_by: stat.completed_by,
      completed_at: stat.completed_at,
      started_by: stat.started_by,
      started_at: stat.started_at,
      percentage_value: stat.percentage,
      started_name: user_name(stat.started_by),
      completed_name: user_name(stat.completed_by),
      medico_legal_case_id: stat.medico_legal_case_id
    }
  end

  defp started_collection(statuses) do
    Enum.filter(statuses, fn stat -> is_nil(stat.started_at) == false &&  is_nil(stat.completed_at) end)
  end

  defp completed_collection(statuses) do
    Enum.filter(statuses, fn stat -> is_nil(stat.started_at) == false &&  is_nil(stat.completed_at) == false end)
  end

  defp user_name(user_id) when is_integer(user_id) do
    user_id
      |> Accounts.get_user!()
      |> User.name_for()
  end

  defp user_name(user_id) when is_nil(user_id)  do
    ""
  end

  defp get_users(mlc) do
    mlc.users
      |> Enum.map(fn x -> x.first_name <> " " <> x.last_name end)
  end

  defp patient_name(mlc) do
    if is_nil(mlc.patient) do
      nil
    else
      mlc.patient.first_name <> " " <> String.upcase(mlc.patient.last_name)
    end
  end
end
