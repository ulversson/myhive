defmodule MyHiveWeb.Settings.AppModuleController do
  use MyHiveWeb, :controller
  alias MyHive.Saas

  def activate(conn, %{"id" => module_id}) do
    account_id = get_session(conn, :account_id)
    case Saas.activate_module(account_id, module_id) do
      {:ok, _} ->
        conn
          |> json(%{
            message: "myHive module has been activated",
            status: "ok"
          })
      {:error, _} ->
        conn
          |> json(%{
            message: "Unable to activate this module",
            status: "false"
          })
    end
  end

    def deactivate(conn, %{"id" => module_id}) do
      account_id = get_session(conn, :account_id)
      case Saas.deactivate_module(account_id, module_id) do
        {:ok, _} ->
          conn
            |> json(%{
              message: "myHive module has been deactivated",
              status: "ok"
            })
        {:error, _} ->
          conn
            |> json(%{
              message: "Unable to deactivate this module",
              status: "false"
            })
      end
    end

end
