defmodule MyHiveWeb.FileManager.DocumentProviderController do
  use MyHiveWeb, :controller
  import MyHive.FileManager.OnlyOfficeLinkGenerator
  alias MyHive.{FileManager, Stats, Accounts, Repo}
  alias MyHive.FileManager.{FileServer, FileUrlDownloader}

  plug :put_layout, false

  def only_office(conn, %{"id" => id}) do
    asset = FileManager.get_file_asset!(id)
    conn |> render("only_office.html", asset: asset,
      callback_url: callback_url(conn, asset),
      download_url: only_office_download_url(conn, asset))
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

  def user_cv(conn, %{"id" => user_id}) do
    current_user = Accounts.get_user!(user_id) |> Repo.preload(:cv)
    conn|> send_download(
      {:file, FileServer.call(current_user.cv)},
        filename: current_user.cv.name,
        content_type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        disposition: :attachment,
        charset: "utf-8"
      )
  end

  def only_office_callback(conn, params) do
    asset = FileManager.get_file_asset!(params["id"])
    if params["status"] == 2 do
      FileUrlDownloader.call(params["url"], FileServer.call(asset))
    end
    conn |> json(%{error: 0})
  end

  def only_office_cv_callback(conn, %{"id" => user_id} = params) do
    current_user = Accounts.get_user!(user_id) |> Repo.preload(:cv)
    if params["status"] == 2 do
      FileUrlDownloader.call(params["url"], FileServer.call(current_user.cv))
    end
    conn |> json(%{error: 0})
  end

end
