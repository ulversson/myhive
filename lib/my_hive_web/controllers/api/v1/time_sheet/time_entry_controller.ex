defmodule MyHiveWeb.Api.V1.TimeSheet.TimeEntryController do

  use MyHiveWeb, :controller
  alias MyHive.TimeSheet
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
        conn |> json(time_entry)
      {:error, changeset} ->
        conn |> MyHiveWeb.FallbackController.call({:error, changeset})
    end
  end
end
