defmodule MyHiveWeb.Profile.ProfileController do
  use MyHiveWeb, :controller
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}
  def show(conn, _params) do
    current_user = conn.assigns.current_user
    settings = current_user.settings |> Ecto.Changeset.change()
      conn |> render("show.html", changeset: settings)
  end

  def update(conn, _params) do
    conn
  end
end
