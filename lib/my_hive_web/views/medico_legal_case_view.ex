defmodule MyHiveWeb.MedicoLegalCaseView do
  use MyHiveWeb, :view
  alias MyHiveWeb.MedicoLegalCaseView

  def render("index.json", %{medico_legal_cases: medico_legal_cases}) do
    %{data: render_many(medico_legal_cases, MedicoLegalCaseView, "medico_legal_case.json")}
  end

  def render("show.json", %{medico_legal_case: medico_legal_case}) do
    %{data: render_one(medico_legal_case, MedicoLegalCaseView, "medico_legal_case.json")}
  end

  def render("medico_legal_case.json", %{medico_legal_case: medico_legal_case}) do
    %{id: medico_legal_case.id,
      user_id: medico_legal_case.user_id,
      folder_id: medico_legal_case.folder_id,
      status: medico_legal_case.status,
      due_date: medico_legal_case.due_date,
      case_summary: medico_legal_case.case_summary,
      note: medico_legal_case.note,
      claimant_defendant: medico_legal_case.claimant_defendant,
      notifications_disabled: medico_legal_case.notifications_disabled,
      patient_deceased: medico_legal_case.patient_deceased}
  end
end
