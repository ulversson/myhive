defmodule MyHiveWeb.FileManager.DocumentProviderController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  plug :put_layout, false
  def only_office(conn, %{"id" => id}) do
    asset = FileManager.get_file_asset!(id)
    download_url = Routes.file_asset_url(MyHiveWeb.Endpoint, :show, asset.id)
      |> String.replace(":4000", "")  |> String.replace("http", "https")
    conn |> render(:only_office, asset: asset, download_url: download_url)
  end


  def only_office_callback(conn, params) do
    asset = FileManager.get_file_asset!(params["id"])
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    #if Integer.parse(body["status"]) == 2 do
      #asset
    #end
    conn |> json(%{error: 0})
  end


end
