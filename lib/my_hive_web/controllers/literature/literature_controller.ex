defmodule MyHiveWeb.Literature.LiteratureController do
  
  use MyHiveWeb, :controller
  plug :put_layout, {MyHiveWeb.LayoutView, :root} 

  def index(conn, params) do
    render(conn, "index.html")
  end

end