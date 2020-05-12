defmodule MyHiveWeb.Profile.ProfileController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}
  def show(conn, _params) do
    current_user = conn.assigns.current_user
    settings = current_user.settings |> Ecto.Changeset.change()
      conn |> render("show.html", changeset: settings)
  end


  def update(conn, %{"settings" => settings}) do
    current_user = conn.assigns.current_user
    FileManager.update_settings(current_user, settings)
    conn |>
      put_flash(:info, "Settings has been saved")
      redirect(conn, to: "/profile")
  end
end
