defmodule MyHiveWeb.FileManager.DocumentProviderController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  def only_office(conn, %{"id" => id}) do
    asset = FileManager.get_file_asset!(id)
    conn |> render(:only_office, asset: asset)
  end

  def only_office_callback(conn, params) do
    asset = FileManager.get_file_asset!(params["id"])
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    require IEx
    if Integer.parse(body["status"]) == 2 do
      asset
    end
    conn |> json(%{error: 0})
  end


end
