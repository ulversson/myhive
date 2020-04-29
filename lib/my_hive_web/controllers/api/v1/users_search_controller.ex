defmodule MyHiveWeb.UsersSearchController do
  use MyHiveWeb, :controller
  alias MyHive.Repo
  alias MyHive.Accounts
  action_fallback MyHiveWeb.ApiFallbackController

  def index(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)
    page = Accounts.query_by_name(params[:q], current_user.id)
      |> Repo.paginate(params)

    render conn, :index,
      users: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
  end

  def for_select(conn, %{"ids" => ids})  do
    users = ids
      |> String.split(",")
      |> Enum.map(fn x -> String.trim(x)  end)
      |> Accounts.get_users_by_ids
      |> Enum.map(fn x -> %{first_name: x.first_name, last_name: x.last_name, id: x.id} end)
    conn |> json(users)
  end

  def for_select(conn, _)  do
    conn |> json([])
  end
end
