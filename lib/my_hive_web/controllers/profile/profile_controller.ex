defmodule MyHiveWeb.Profile.ProfileController do
  use MyHiveWeb, :controller
  alias MyHive.{
    FileManager, Accounts, EmailTemplates
  }

  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}

  def show(conn, _params) do
    current_user = conn.assigns.current_user
    quick_links = Accounts.quick_links_for_user(current_user.id)
    settings = current_user.settings |> Ecto.Changeset.change()
    signature = EmailTemplates.user_signature(current_user)
      conn |> render("show.html",
        changeset: settings,
        current_user: current_user,
        signature: signature,
        quick_links: quick_links
      )
  end

  def update(conn, %{
    "settings" => settings,
    "signature" => signature
    }) do
    current_user = conn.assigns.current_user
    FileManager.update_settings(current_user, settings)
    EmailTemplates.update_signature(current_user.id, signature)
    conn |>
      put_flash(:info, "Settings has been saved")
      redirect(conn, to: "/profile")
  end
end
