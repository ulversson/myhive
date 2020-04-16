defmodule MyHiveWeb.MedicoLegalCaseController do
  use MyHiveWeb, :controller

  alias MyHive.CaseManagement
  alias MyHive.CaseManagement.MedicoLegalCase

  action_fallback MyHiveWeb.FallbackController

  def index(conn, _params) do
    medico_legal_cases = CaseManagement.list_medico_legal_cases()
    render(conn, "index.json", medico_legal_cases: medico_legal_cases)
  end

  def create(conn, %{"medico_legal_case" => medico_legal_case_params}) do
    with {:ok, %MedicoLegalCase{} = medico_legal_case} <- CaseManagement.create_medico_legal_case(medico_legal_case_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.medico_legal_case_path(conn, :show, medico_legal_case))
      |> render("show.json", medico_legal_case: medico_legal_case)
    end
  end

  def show(conn, %{"id" => id}) do
    medico_legal_case = CaseManagement.get_medico_legal_case!(id)
    render(conn, "show.json", medico_legal_case: medico_legal_case)
  end

  def update(conn, %{"id" => id, "medico_legal_case" => medico_legal_case_params}) do
    medico_legal_case = CaseManagement.get_medico_legal_case!(id)

    with {:ok, %MedicoLegalCase{} = medico_legal_case} <- CaseManagement.update_medico_legal_case(medico_legal_case, medico_legal_case_params) do
      render(conn, "show.json", medico_legal_case: medico_legal_case)
    end
  end

  def delete(conn, %{"id" => id}) do
    medico_legal_case = CaseManagement.get_medico_legal_case!(id)

    with {:ok, %MedicoLegalCase{}} <- CaseManagement.delete_medico_legal_case(medico_legal_case) do
      send_resp(conn, :no_content, "")
    end
  end
end
