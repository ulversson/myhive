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
                        :owner_id,
                        :note_issued,
                        :medico_legal_case_id,
                        :inserted_at,
                        :note])
    query
      |> joins(params["mlc_id"])
      |> where_query(search_term)
      |> order_query(direction(params["ascending"]), params["orderBy"])
      |> Repo.paginate(page: page_number,  page_size: page_size)
  end

  defp direction(dir) do
    case dir do
      "true" -> :asc
      "false" -> :desc
    end
  end

  defp joins(query, mlc_id) when is_binary(mlc_id) do
    from te in query,
    join: mlc in assoc(te, :medico_legal_case),
    join: o in assoc(te, :owner),
    join: p in assoc(mlc, :patient),
    preload: [{:medico_legal_case, :patient}],
    where: o.id == te.owner_id,
    preload: [:owner],
    where: te.medico_legal_case_id == ^mlc_id
  end

  defp joins(query, mlc_id) when is_nil(mlc_id) do
    from te in query,
    join: mlc in assoc(te, :medico_legal_case),
    join: o in assoc(te, :owner),
    join: p in assoc(mlc, :patient),
    where: o.id == te.owner_id,
    preload: [:owner],
    preload: [{:medico_legal_case, :patient}]
  end

  def order_query(query, :asc, "start_date"),
  do: query |> order_by([te], asc: te.start_date, asc: te.end_date)

  def order_query(query, :asc, "end_date"),
  do: query |> order_by([te],  asc: te.end_date, asc: te.start_date)

  def order_query(query, :desc, "start_date"),
  do: query |> order_by([te], desc: te.start_date, desc: te.end_date)

  def order_query(query, :desc, "end_date"),
  do: query |> order_by([te],  desc: te.end_date, desc: te.start_date)

  def order_query(query, :asc, "owner") do
    query |> order_by([te, mlc, o],  asc: o.first_name, asc: o.last_name)
  end

  def order_query(query, :desc, "owner") do
    query |> order_by([te, mlc, o],  desc: o.first_name, desc: o.last_name)
  end

  def order_query(query, :asc, "case") do
    query |> order_by([te, mlc, o, p],  asc: p.first_name, asc: p.last_name)
  end

  def order_query(query, :desc, "case") do
    query |> order_by([te, mlc, o, p],  desc: p.first_name, desc: p.last_name)
  end

  def order_query(query, :asc, _),
  do: query |> order_by([te,p], asc: te.id)

  def order_query(query, :desc, _),
  do: query |> order_by([te, p], desc: te.id)

  def where_query(query, %{"id" => id}) when not (id == "") do
    where(query, [mlc,p], mlc.id == ^id)
  end

  def where_query(query, %{"case" => patient}) when not(patient == "") do
    value = "%#{patient}%"
    where(query, [te, mlc, o, p], ilike(p.first_name, ^value)
      or ilike(p.last_name, ^value))
  end

  def where_query(query, %{"owner" => owner}) when not(owner == "") do
    value = "%#{owner}%"
    where(query, [te, mlc, o, p], ilike(o.first_name, ^value)
      or ilike(o.last_name, ^value))
  end

  def where_query(query,_) do
    query
  end

end
