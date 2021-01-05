defmodule MyHiveWeb.Api.V1.TimelineController do
  use MyHiveWeb, :controller
  alias MyHive.{Repo, CaseManagement}
  alias  MyHive.CaseManagement.Services.TimelineOrganizer

  def create(conn, params) do
    case CaseManagement.create_medico_legal_case_status(params["medico_legal_case_id"], params["name"]) do
      status ->
        statuses = CaseManagement.get_case_with_stages(params["medico_legal_case_id"])
        conn |> render("statuses.json", %{
          statuses: statuses
        })
      {:error, changeset} ->
        MyHiveWeb.FallbackController.call({:error, changeset})
    end
  end

  def patch(conn, %{"id" => id, "statuses" => statuses}) do
    TimelineOrganizer.call(statuses)
    statuses = CaseManagement.get_case_with_stages(id)
    conn |> render("statuses.json", %{
      statuses: statuses
    })
  end

  def update_status(conn, %{"id" => status_id, "name" => name}) do
    status_id
      |> CaseManagement.find_status_by_id()
      |> CaseManagement.update_medico_legal_case_status(%{name: name})
    conn |> json(%{"status" => true, "message" => "ok"})
  end

  def delete(conn, %{"id" => status_id}) do
    case CaseManagement.find_status_by_id(status_id) do
      nil ->
        conn
          |> put_status(422)
          |> json(%{success: false} )
      status ->
        Repo.transaction(fn ->
          Repo.delete(status)
          CaseManagement.recalculate_case_progress(status.medico_legal_case_id)
        end)
        conn |> json(%{
          "success" => true,
          "message" => "Timeline item removed",
          "status" => "ok"
        })
    end
  end

  def reset(conn, %{"id" => mlc_id}) do
    case CaseManagement.get_case_with_stages(mlc_id) do
      [] ->
        conn
        |> put_status(422)
        |> json(%{success: false} )
      statuses ->
        CaseManagement.reset_stages(statuses, mlc_id)
        conn |> json(%{
          "success" => true,
          "message" => "Timeline item removed",
          "status" => "ok"
        })
    end
  end
end
