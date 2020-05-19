defmodule MyHiveWeb.Settings.SettingsController do
  use MyHiveWeb, :controller
  alias MyHive.Saas.{
    Account
  }
  alias MyHive.{
    Repo, Saas
  }
  plug :scrub_params, "account" when action in [:create, :update]
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}
  def index(conn, _params) do
    changeset = conn
      |> default_saas_account()
      |> Account.changeset(%{})
    acc = account(conn)
      |> Account.preload_folder_trees()
    conn |> render("index.html",
      changeset: changeset,
      app_modules: Saas.app_modules(),
      account: acc)
  end

  def upload_logo(conn, %{"files" => files}) do
    acc = account(conn)
    file = files |> List.first |> Map.from_struct()
    Saas.add_logo(acc, file)
    conn |> json(%{"success" => true})
  end

  def update(conn, %{"account" => settings}) do
    case Saas.update_settings(account(conn), settings) do
      {:ok, _acc} ->
        conn |>
          put_flash(:info, "Settings has been saved")
          redirect(conn, to: "/settings#general")
      {:error, _changeset} ->
        conn |>
        put_flash(:error, "Could not change settings")
        redirect(conn, to: "/settings#general")
    end
  end

  defp default_saas_account(conn) do
    acc = account(conn)
    Repo.preload(acc, [:address])
  end

  defp account(conn) do
    conn.assigns.current_user.saas_accounts |> List.first
  end
end
