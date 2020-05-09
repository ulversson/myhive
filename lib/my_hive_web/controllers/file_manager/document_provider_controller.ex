defmodule MyHiveWeb.FileManager.DocumentProviderController do
  use MyHiveWeb, :controller
  alias MyHive.{FileManager, Stats}
  alias MyHive.FileManager.{FileServer}

  plug :put_layout, false
  def only_office(conn, %{"id" => id}) do
    asset = FileManager.get_file_asset!(id)
    conn |> render("only_office.html", asset: asset,
      download_url: only_office_download_url(asset))
  end

  def only_office_asset(conn, %{"id" => id, "user_id" => user_id}) do
    asset = FileManager.get_file_asset!(id)
    Stats.first_or_create(%{
      countable_id: id,
      countable_type: "FileAsset",
      viewed_by: user_id
    })
    conn
    |> send_download(
      {:file, FileServer.call(asset)},
      filename: asset.name,
      content_type: asset.filetype,
      disposition: :attachment,
      charset: "utf-8"
    )
  end


  def only_office_callback(conn, params) do
    asset = FileManager.get_file_asset!(params["id"])
    #{:ok, body, _conn} = Plug.Conn.read_body(conn)
    #if Integer.parse(body["status"]) == 2 do
      #asset
    #end
    conn |> json(%{error: 0})
  end

  defp only_office_download_url(asset) do
    Routes.file_asset_url(MyHiveWeb.Endpoint, :show, asset.id)
      |> String.replace(":4000", "")  |> String.replace("http", "https")
  end


end
