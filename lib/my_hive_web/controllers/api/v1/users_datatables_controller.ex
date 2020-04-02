defmodule MyHiveWeb.UsersDatatablesController do
  use MyHiveWeb, :controller
  alias MyHiveWeb.Datatables.DatatablesParamsParser
  alias MyHive.Datatables.UsersDtFetcher
  plug MyHiveWeb.Plugs.AuthorizationPlug, :admin
  action_fallback MyHiveWeb.ApiFallbackController
  
  def index(conn, params) do
    {page_size, page_number, draw_number, search_term} = DatatablesParamsParser.build_paging_info(params)
    users = UsersDtFetcher.get_users(page_size, page_number, search_term)
    render(conn, 
      :index,
      users: users,
      page_number: page_number,
      draw_number: draw_number)
  end
end