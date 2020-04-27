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
end
