defmodule MyHiveWeb.Api.V1.TimeSheet.TimeEntryController do

  use MyHiveWeb, :controller
  alias MyHive.{
    TimeSheet, Repo
  }
  alias MyHive.Datatables.TimeEntriesFetcher
  import MyHiveWeb.Datatables.VueTableParamsParser

  action_fallback MyHiveWeb.FallbackController

  def index(conn, params) do
    {page_size, page, query, _} = build_paging_info(params)
    page = TimeEntriesFetcher.get_cases(page_size, page, query, params)
    render conn, :index,
      time_entries: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
  end

  def create(conn, %{"time_entry" => time_entry_params}) do
    case TimeSheet.create_time_entry(time_entry_params) do
      {:ok, time_entry} ->
        time_entry = Repo.preload(time_entry, [{:medico_legal_case, :patient}, :owner])
        conn |> json(time_entry)
      {:error, changeset} ->
        conn |> MyHiveWeb.FallbackController.call({:error, changeset})
    end
  end

  def update(conn, %{"id" => id,
    "field" => field, "value" => value}) do
    case TimeSheet.get_time_entry(id) do
      nil ->
        conn |> send_resp(404, "")
      time_sheet ->
       {:ok, res} = TimeSheet.update_time_entry(
          time_sheet,
          %{field => value}
        )
        conn |> send_resp(200, "")
    end
  end

  def destroy(conn, %{"id" => id}) do
    TimeSheet.del_time_entry(id)
    conn |> json(%{"status" => "ok"})
  end

end
