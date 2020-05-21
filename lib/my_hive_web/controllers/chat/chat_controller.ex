defmodule MyHiveWeb.Chat.ChatController do
  use MyHiveWeb, :controller
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}
  def index(conn, _params) do
    conn |> render("index.html")
  end
end
