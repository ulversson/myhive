defmodule MyHiveWeb.GlossaryOfTermController do
  use MyHiveWeb, :controller
  plug :put_layout, {MyHiveWeb.LayoutView, :root}
  

  def index(conn, _) do
    render("index.html")
  end
end