defmodule MyHiveWeb.FileManager.FileAssetController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager
  alias MyHive.FileManager.{FileServer}

  def show(conn, %{"id" => id}) do
    asset = FileManager.get_file_asset!(id)
    conn |> send_download(
      {:file, FileServer.call(asset)},
      filename: asset.name,
      content_type: asset.filetype,
      disposition: :inline,
      charset: "utf-8"
    )
  end


end
