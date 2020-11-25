defmodule MyHiveWeb.FileManager.RecycleBinController do
  use MyHiveWeb, :controller
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
