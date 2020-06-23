defmodule MyHive.Datatables.TimeEntriesFetcher do

  alias MyHive.Repo
  alias MyHive.TimeSheet.TimeEntry
  alias MyHive.Accounts
  import Ecto.Query

  def get_cases(page_size, page_number, search_term, params) do
    query = from te in TimeEntry,
    select: struct(te, [:id,
                        :start_date,
                        :end_date,
                        :description,
                        :note_issued,
                        :medico_legal_case_id,
                        :inserted_at,
                        :note])
    query
      |> order_query(direction(params["ascending"]), params["orderBy"])
      |> joins(params["mlc_id"])
      |> Repo.paginate(page: page_number,  page_size: page_size)
  end

  defp direction(dir) do
    case dir do
      "true" -> :asc
      "false" -> :desc
    end
  end

  defp joins(query, mlc_id) do
    from te in query,
    preload: [:medico_legal_case],
    where: te.medico_legal_case_id == ^mlc_id
  end

  def order_query(query, :asc, "start_date"),
  do: query |> order_by([te], asc: te.start_date, asc: te.end_date)

  def order_query(query, :asc, "end_date"),
  do: query |> order_by([te],  asc: te.end_date, asc: te.start_date)

  def order_query(query, :desc, "start_date"),
  do: query |> order_by([te], desc: te.start_date, desc: te.end_date)

  def order_query(query, :desc, "end_date"),
  do: query |> order_by([te],  desc: te.end_date, desc: te.start_date)

  def order_query(query, :asc, _),
  do: query |> order_by([te,p], asc: te.id)

  def order_query(query, :desc, _),
  do: query |> order_by([te, p], desc: te.id)

end
