defmodule MyHiveWeb.Api.V1.SettingsController do
  use MyHiveWeb, :controller
  action_fallback MyHiveWeb.FallbackController

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    conn |> json(%{settings: current_user.settings})
  end
end
