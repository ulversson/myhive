defmodule MyHiveWeb.FileManager.FileAssetController do
  use MyHiveWeb, :controller
  alias MyHive.{FileManager, Stats}
  alias MyHive.FileManager.{FileServer}

  def show(conn, %{"id" => id}) do
    asset = FileManager.get_file_asset!(id)
    Stats.first_or_create(%{
      countable_id: id,
      countable_type: "FileAsset",
      viewed_by: conn.assigns.current_user.id
    })
    conn
    |> send_download(
      {:file, FileServer.call(asset)},
      filename: asset.name,
      content_type: asset.filetype,
      disposition: :inline,
      charset: "utf-8"
    )
  end


end
