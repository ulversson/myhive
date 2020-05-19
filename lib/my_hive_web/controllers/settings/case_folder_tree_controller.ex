defmodule MyHiveWeb.Settings.CaseFolderTreeController do
  use MyHiveWeb, :controller
  alias MyHive.Saas.CaseFolderTree
  alias MyHive.Saas
  alias MyHive.Saas.Services.{
    TreeActivator,
    TreeHoover
  }
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}
  def new(conn, _params) do
    changeset = Ecto.Changeset.change(%CaseFolderTree{})
    account_id = get_session(conn, :account_id)
    conn
      |> render("new.html", changeset: changeset,
        account_id: account_id)
  end

  def create(conn, %{"case_folder_tree" => params}) do
    case Saas.create_case_folder_tree(params) do
      {:ok, _} ->
        conn
          |> put_flash(:info, "Case folder tree successfully saved")
          |> redirect(to: "/settings#medic-legal-cases")
      {:error, changeset} ->
        account_id = get_session(conn, :account_id)
        conn
          |> assign(:changeset, changeset)
          |> assign(:account_id, account_id)
          |> render(:new)
    end
  end

  def activate(conn, %{"id" => id}) do
    account_id = get_session(conn, :account_id)
    case TreeActivator.call(account_id, id) do
     {:ok, _} ->
        conn
          |> json(%{
            message: "Directory tree has been activated",
            status: "ok"
          })
      {:error, _} ->
        conn
          |> put_status(422)
          |> json(%{
            message: "Could not activate this tree",
            status: "false"
          })
    end
  end

  def destroy(conn, %{"id" => id}) do
    account_id = get_session(conn, :account_id)
    case TreeHoover.call(account_id, id) do
     {:ok, _} ->
        conn
          |> json(%{
            message: "Directory tree has been removed",
            status: "ok"
          })
      {:error, _} ->
        conn
          |> put_status(422)
          |> json(%{
            message: "Could not remvoe this tree",
            status: "false"
          })
    end
  end
end
