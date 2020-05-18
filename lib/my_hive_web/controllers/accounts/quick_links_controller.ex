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
          |> redirect(to: "/profile#p-quick-links")
      {:error, changeset} ->
        conn
          |> assign(:changeset, changeset)
          |> render(:new)
    end
  end

  def destroy(conn, %{"id" => id }) do
    case Accounts.get_quick_link!(id) do
     nil ->
        conn
        |> put_status(422)
        |> json(%{
          message: "Quick link could not be deleted.",
          status: "false"
        })
     link ->
        Accounts.delete_link(link)
        conn
          |> json(%{
            message: "Quick link has been successfully deleted.",
            status: "ok"
          })
    end
  end

end
