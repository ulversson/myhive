defmodule MyHiveWeb.Profile.ProfileController do
  use MyHiveWeb, :controller
  alias MyHive.{
    FileManager, Accounts, Repo
  }
  alias MyHive.FileManager.FileServer
  alias MyHive.Accounts.CvPdfDownloader

  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}
  def show(conn, _params) do
    current_user = conn.assigns.current_user |> Repo.preload(:cv)
    quick_links = Accounts.quick_links_for_user(current_user.id)
    settings = current_user.settings |> Ecto.Changeset.change()
      conn |> render("show.html",
        changeset: settings,
        current_user: current_user,
        quick_links: quick_links)
  end


  def cv(conn, %{"user_id" => user_id, "type" => "word"}) do
    current_user = Accounts.get_user!(user_id) |> Repo.preload(:cv)
    conn|> send_download(
      {:file, FileServer.call(current_user.cv)},
        filename: current_user.cv.name,
        content_type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        disposition: :attachment,
        charset: "utf-8"
      )
  end

  def cv(conn, %{"user_id" => user_id, "type" => "pdf"}) do
    CvPdfDownloader.call(user_id)
    conn|> send_download(
      {:file, CvPdfDownloader.pdf_path(user_id)},
        filename: "cv.pdf",
        content_type: "application/pdf",
        disposition: :attachment,
        charset: "utf-8"
      )
  end

  def update(conn, %{"settings" => settings}) do
    current_user = conn.assigns.current_user
    FileManager.update_settings(current_user, settings)
    conn |>
      put_flash(:info, "Settings has been saved")
      redirect(conn, to: "/profile")
  end
end
