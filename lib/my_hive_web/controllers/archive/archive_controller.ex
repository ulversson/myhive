defmodule MyHiveWeb.Archive.ArchiveController do
  use MyHiveWeb, :controller
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root} when action not in [:create]

  def index(conn, _params) do
    conn |> render("index.html")
  end
end
