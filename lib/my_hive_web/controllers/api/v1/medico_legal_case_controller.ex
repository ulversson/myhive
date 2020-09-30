defmodule MyHiveWeb.MedicoLegalCaseController do
  use MyHiveWeb, :controller
  alias MyHive.CaseManagement
  alias MyHive.Datatables.MedicoLegalCasesFetcher
  alias MyHive.CaseManagement.Services.MedicoLegalCaseGenerator
  alias MyHive.CaseManagment.Services.{
    MedicoLegalCaseMobileParamsParser
  }
  import MyHiveWeb.Datatables.VueTableParamsParser
  action_fallback MyHiveWeb.FallbackController

  def create(conn, %{"medico_legal_case" => %{"user_names" => names} = params}) do
    user = Guardian.Plug.current_resource(conn)
    params = MedicoLegalCaseMobileParamsParser.call(params, user)
    case MedicoLegalCaseGenerator.call(params) do
      {:ok, _} ->
        conn |> json(%{"success" => true, "message" => "ok"})
      changeset ->
        conn
        |> put_status(422)
        |> render("422.json", changeset: changeset)
    end
  end

  def index(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)
    params = Map.put(params, "current_user_id", current_user.id)
    {page_size, page, query, _} = build_paging_info(params)
    page = MedicoLegalCasesFetcher.get_cases(page_size, page, query, params)
    render conn, :index,
      medico_legal_cases: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      role: current_user.roles,
      total_pages: page.total_pages,
      total_entries: page.total_entries
  end

  def show(conn, %{"id" => id}) do
    medico_legal_case = CaseManagement.get_case_with_data(id)
    render(conn, "show.json", medico_legal_case: medico_legal_case)
  end

  def notification_off(conn, %{"id" => id}) do
    id
      |> CaseManagement.get_case_with_data()
      |> CaseManagement.update_case(%{notifications_disabled: true})
    json(conn, %{"status" => "ok"})
  end


end
