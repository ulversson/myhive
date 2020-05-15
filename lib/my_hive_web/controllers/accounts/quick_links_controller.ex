defmodule MyHiveWeb.Accounts.QuickLinksController do
  import Plug.Conn
  use MyHiveWeb, :controller
  alias MyHive.Accounts.QuickLink
  alias MyHive.{
    Accounts
  }
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}
  def new(conn, _params) do
    changeset = Ecto.Changeset.change(%QuickLink{})
    conn |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"quick_link" => params }) do
    case Accounts.create_quick_link(params) do
      {:ok, _} ->
        conn
          |> put_flash(:info, "Link has been successfully saved")
          |> redirect(to: "/profile")
      {:error, _changeset} ->
        conn
          |> put_flash(:error, "All fields are mandatory")
          |> redirect(to: "/profile")
    end
  end

end
