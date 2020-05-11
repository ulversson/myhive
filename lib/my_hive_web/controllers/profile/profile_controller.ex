defmodule MyHiveWeb.Profile.ProfileController do
  use MyHiveWeb, :controller
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}
  def show(conn, _params) do
    conn |> render("show.html")
  end
end
