defmodule MyHiveWeb.MedicoLegalCaseView do
  use MyHiveWeb, :view
  alias MyHiveWeb.MedicoLegalCaseView
  require IEx
  def render("index.json", %{medico_legal_cases: medico_legal_cases,
    page_number: page_number,
    page_size: page_size,
    total_entries: total_entries,
    total_pages: total_pages}) do
    %{data:
      render_many(medico_legal_cases, MedicoLegalCaseView, "medico_legal_case.json"),
      page: page_number,
      limit: page_size,
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
      due_date: medico_legal_case.due_date,
      case_summary: medico_legal_case.case_summary,
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
    %{id: medico_legal_case.id,
      user_id: medico_legal_case.user_id,
      folder_id: medico_legal_case.folder_id,
      users: get_users(medico_legal_case),
      created_at: medico_legal_case.inserted_at,
      patient: patient_name(medico_legal_case),
      deceased: medico_legal_case.patient.deceased,
      status: medico_legal_case.status,
      due_date: medico_legal_case.due_date,
      case_summary: medico_legal_case.case_summary,
      note: medico_legal_case.note,
      notifications_disabled: medico_legal_case.notifications_disabled}
  end

  defp get_users(mlc) do
    mlc.users# |>
   # MyHive.CaseManagement.user_ids_for_case
     # |> MyHive.Accounts.get_users_by_ids
      |> Enum.map(fn x -> x.first_name <> " " <> x.last_name end)
  end

  defp patient_name(mlc) do
    if is_nil(mlc.patient) do
      nil
    else
      mlc.patient.first_name <> " " <> mlc.patient.last_name
    end
  end
end