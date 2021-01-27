defmodule MyHive.Datatables.MedicoLegalCasesFetcher do

  alias MyHive.Repo
  alias MyHive.CaseManagement.MedicoLegalCase
  alias MyHive.Accounts
  import Ecto.Query

  def get_cases(page_size, page_number, search_term, params) do
    query = from mlc in MedicoLegalCase,
    select: struct(mlc, [:id, :instructed_by,
                         :inserted_at,
                         :due_date,
                         :started_at,
                         :folder_id,
                         :settled_at,
                         :status,
                         :note,
                         :file_reference,
                         :patient_id, :user_id,
                         :account_id])
    query
      |> joins()
      |> order_query(direction(params["ascending"]), params["orderBy"])
      |> where_query(search_term, params["current_user_id"])
      |> by_account_and_user(params["current_user_id"])
      |> by_status(params)
      |> group_by([mlc, p, u], [mlc.id, p.first_name, p.last_name])
      |> Repo.paginate(page: page_number,  page_size: page_size)
  end

  defp direction(dir) do
    case dir do
      "true" -> :asc
      "false" -> :desc
    end
  end

  defp joins(query) do
    from mlc in query,
    preload: [:users, :account, :patient, :user],
    join: p in assoc(mlc, :patient),
    join: u in assoc(mlc, :users)
  end

  def order_query(query, :asc, "users") do
    query
  end

  def order_query(query, :asc, "patient"),
  do: query |> order_by([mlc,p], asc: p.last_name, asc: p.first_name)

  def order_query(query, :asc, "created_at"),
  do: query |> order_by([mlc,p], asc: mlc.inserted_at)

  def order_query(query, :desc, "users"),
  do: query

  def order_query(query, :desc, "patient"),
  do: query |> order_by([mlc,p], desc: p.last_name, desc: p.first_name)

  def order_query(query, :desc, "created_at"),
  do: query |> order_by([mlc,p], desc: mlc.inserted_at)

  def order_query(query, :asc, _),
  do: query |> order_by([mlc,p], asc: mlc.id)

  def order_query(query, :desc, _),
  do: query |> order_by([mlc, p], desc: mlc.id)

  def where_query(query, %{"patient" => patient}, _) when not(patient == "") do
    value = "%#{patient}%"
    where(query, [mlc,p], ilike(p.first_name, ^value)
      or ilike(p.last_name, ^value))
  end

  def where_query(query, %{"users" => users}, user_id) when not(users == "") and is_nil(user_id) == false do
    query = from mlc in query,
    join: u in assoc(mlc, :users),
    join: u2 in assoc(mlc, :user_medico_legal_cases)
    value = "%#{users}%"
    query = where(query, [mlc, p, u, u1, u2], ilike(u1.first_name, ^value)
    or ilike(u1.last_name, ^value) and u2.user_id == ^user_id)
  end

  def where_query(query, %{"id" => id}, _user_id) when not (id == "") do
    where(query, [mlc,p], mlc.id == ^id)
  end

  def where_query(query, %{"created_at" => created}, _user_id) when not(created == "") do
    {:ok, date} = Timex.parse(created, "%d/%m/%Y", :strftime)
    where(query, [mlc,p], mlc.inserted_at > ^date)
  end

  def where_query(query, %{"patient" => patient, "users" => users}, user_id) when not(patient == "") and not(users == "") do
    query |> where_query(%{"patient" => patient}, nil) |> where_query(%{"users" => users}, user_id)
  end

  def where_query(query, %{"users" => users, "patient" => patient}, user_id) when not(patient == "") and not(users == "") do
    query |> where_query(%{"users" => users}, user_id) |> where_query(%{"patient" => patient}, nil)
  end

  def where_query(query,_, _) do
    query
  end

  defp by_status(query, %{"tab" => status}) do
    where(query, [mlc,p], mlc.status == ^status)
  end

  defp by_account_and_user(query, user_id) do
    user = user_id |> Accounts.get_user!

    if Accounts.is_super_admin?(user) do
      query
    else
      accounts_ids = Accounts.get_accounts_ids(user)
      where(query, [mlc,p,u], mlc.account_id in ^accounts_ids)
      |> where([mlc,p,u, u2], (mlc.user_id ==^user_id or u.id == ^user_id))
    end
  end

end
