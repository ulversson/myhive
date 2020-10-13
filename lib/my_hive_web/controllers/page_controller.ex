defmodule MyHiveWeb.PageController do
  use MyHiveWeb, :controller
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}


  def index(conn, _params) do
    jwt = get_session(conn, :jwt)
    ref = get_session(conn, :ref)
    conn
      |> assign(:jwt, jwt)
      |> assign(:ref, ref)
      |> render("index.html")
  end

  def show(conn, _params) do
    render(conn, "index.html")
  end
end
