defmodule MyHiveWeb.Plugs.MaintenancePlug do
  import Plug.Conn

  @maintenance_file "/tmp/maintenance.txt"

  def init(options), do: options

  def call(conn, _) do
    case File.exists?(@maintenance_file) do
      true ->
        conn
          |> Phoenix.Controller.html(File.read!("priv/static/maintenance.html"))
          |> halt()
        false
        -> conn
    end
  end
end
