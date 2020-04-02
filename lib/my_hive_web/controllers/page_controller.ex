defmodule MyHiveWeb.PageController do
  use MyHiveWeb, :controller
  require IEx
  def index(conn, _params) do
    jwt = get_session(conn, :jwt)
    conn 
      |> assign(:jwt, jwt)
      |> render("index.html")
  end

  def show(conn, _params) do
    render(conn, "index.html")
  end
end
