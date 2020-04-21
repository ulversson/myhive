defmodule MyHiveWeb.UsersSearchController do
  use MyHiveWeb, :controller
  alias MyHive.Repo
  alias MyHive.Accounts
  action_fallback MyHiveWeb.ApiFallbackController

  def index(conn, params) do

    page = Accounts.query_by_name(params[:q])
      |> Repo.paginate(params)

    render conn, :index,
      users: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
  end
end
