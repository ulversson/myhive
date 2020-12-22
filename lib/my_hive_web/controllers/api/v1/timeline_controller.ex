defmodule MyHiveWeb.Api.V1.TimelineController do
  use MyHiveWeb, :controller
  alias MyHive.CaseManagement
  alias  MyHive.CaseManagement.Services.TimelineOrganizer

  def patch(conn, %{"id" => id, "statuses" => statuses}) do
    TimelineOrganizer.call(statuses)
    mlc = CaseManagement.get_case_with_stages(id)
    conn |> render("statuses.json", %{
      statuses: mlc.medico_legal_case_statuses
    })
  end

  def update_status(conn, %{"id" => status_id, "name" => name}) do
    status_id
      |> CaseManagement.find_status_by_id()
      |> CaseManagement.update_medico_legal_case_status(%{name: name})
    conn |> json(%{"status" => true, "message" => "ok"})
  end
end
