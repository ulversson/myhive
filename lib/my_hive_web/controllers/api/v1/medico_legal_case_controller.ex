defmodule MyHiveWeb.MedicoLegalCaseController do
  use MyHiveWeb, :controller
  alias MyHive.CaseManagement
  alias MyHive.Datatables.MedicoLegalCasesFetcher
  alias MyHive.CaseManagement.Services.{
    MedicoLegalCaseMobileParamsParser,
    MedicoLegalCaseGenerator,
    MedicoLegalCaseHoover,
    MedicoLegalCaseUpdater,
  }
  alias MyHive.CaseManagement.{
    MedicoLegalCaseNotifier
  }
  alias MyHive.Repo
  alias MyHive.CaseManagement.MedicoLegalCaseStatus
  import MyHiveWeb.Datatables.VueTableParamsParser
  action_fallback MyHiveWeb.FallbackController

  def create(conn, %{"medico_legal_case" => %{"user_names" => _names} = params}) do
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

  def status(conn, params) do
    {:ok, mlc} = params["id"]
      |> CaseManagement.get_medico_legal_case!
      |> CaseManagement.change_status(params["status"])
    mlc = MyHive.Repo.preload(mlc, [:users])
    Enum.each(mlc.users, fn  user ->
      MedicoLegalCaseNotifier.call(user, mlc)
    end)
    conn
      |> json(%{
      message: "Status has been updated",
      status: "ok"
    })
  end

  def delete(conn, %{"id" => id}) do
    MedicoLegalCaseHoover.call(id)
    conn
      |> json(%{
        message: "Case has been successfully removed",
        status: "ok"
      })
  end

  def edit(conn, %{"id" => id}) do
    medico_legal_case = CaseManagement.get_case_with_data(id)
    conn |> json(%{data: medico_legal_case})
  end

  def update(conn, %{
      "id" => id,
      "medico_legal_case" => %{"user_names" => _names} = params}) do
    user = Guardian.Plug.current_resource(conn)
    mlc = CaseManagement.get_case_with_data(id)
    params = MedicoLegalCaseMobileParamsParser.call(params, user)
    case MedicoLegalCaseUpdater.call(mlc, params) do
      {:ok, _} ->
        conn |> json(%{"success" => true, "message" => "ok"})
      changeset ->
        conn
        |> put_status(422)
        |> render("422.json", changeset: changeset)
    end
  end

  def stages(conn, %{"id" => id}) do
    case CaseManagement.get_case_with_stages(id) do
      [] ->
        conn |> put_status(404)
      statuses ->
        conn |> render("statuses.json", %{
          statuses: statuses
        })
    end
  end

  def next_status(conn, %{"id" => _mlc_id, "status_id" => status_id}) do
    user = Guardian.Plug.current_resource(conn)
    status = status_id
      |> CaseManagement.find_status_by_id()
      |> MedicoLegalCaseStatus.next_status(user.id)
      |> Repo.preload([
          :medico_legal_case,
          :medico_legal_case_progress_state,
          :user,
          :starter
        ])
    conn |> render("status.json", %{
      status: status
    })
  end

end
