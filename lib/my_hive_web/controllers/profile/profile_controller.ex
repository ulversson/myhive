defmodule MyHiveWeb.Profile.ProfileController do
  use MyHiveWeb, :controller
  alias MyHive.{
    FileManager, Accounts
  }

  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}
  def show(conn, _params) do
    current_user = conn.assigns.current_user
    quick_links = Accounts.quick_links_for_user(current_user.id)
    settings = current_user.settings |> Ecto.Changeset.change()
      conn |> render("show.html",
        changeset: settings, quick_links: quick_links)
  end


  def update(conn, %{"settings" => settings}) do
    current_user = conn.assigns.current_user
    FileManager.update_settings(current_user, settings)
    conn |>
      put_flash(:info, "Settings has been saved")
      redirect(conn, to: "/profile")
  end
end
