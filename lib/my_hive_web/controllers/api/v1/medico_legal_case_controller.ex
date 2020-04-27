defmodule MyHiveWeb.MedicoLegalCaseController do
  use MyHiveWeb, :controller

  alias MyHive.CaseManagement
  alias MyHive.CaseManagement.MedicoLegalCase
  alias MyHive.Datatables.MedicoLegalCasesFetcher
  import MyHiveWeb.Datatables.VueTableParamsParser
  action_fallback MyHiveWeb.FallbackController
  require IEx
#{ query:'query', limit:'limit', orderBy:'orderBy', ascending:'ascending', page:'page', byColumn:'byColumn' }
  def index(conn, params) do
    params = Map.put(params, "current_user_id", Guardian.Plug.current_resource(conn).id)
    {page_size, page, query, _} = build_paging_info(params)
    page = MedicoLegalCasesFetcher.get_cases(page_size, page, query, params)
    render conn, :index,
      medico_legal_cases: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
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
