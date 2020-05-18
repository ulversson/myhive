defmodule MyHiveWeb.Shareables.ShareableController do
  use MyHiveWeb, :controller
  plug :put_layout, false when action in [:download]

  alias MyHive.{
    Accounts,
    Shareable,
    FileManager
  }
  alias MyHive.Shareable.Directory
  alias MyHive.FileManager.FileServer
  alias MyHiveWeb.Plugs.ShareableDirectoryNotifier
  alias MyHiveWeb.FallbackController

  def verify(conn, %{"token" => token, "email" => email}) do
    dir = get_session(conn, :dir)
    if Directory.valid_for_email?(dir, email) do
      ShareableDirectoryNotifier.call(dir, email)
      conn
        |> redirect(to: "/shared/view/#{token}?email=#{email}")
    else
      conn |> invalid_request()
    end
  end

  def view(conn, %{"token" => _token, "email" => _email}) do
    dir = conn |> get_session(:dir) |> Shareable.preload_all()
    conn
      |> assign(:dir, dir)
      |> assign(:col, color())
      |> render(:view)
  end

  defp invalid_request(conn) do
    conn
      |> put_flash(:error, "Unauthorized request")
      |> redirect(to: "/")
  end

  def download(conn,
    %{"token" => _token, "email" => _email, "id" => id}) do
    dir = get_session(conn, :dir)
    case FileManager.get_file_asset!(id) do
      nil ->
        conn |> FallbackController.call({:error, :not_found})
      asset ->
        Directory.is_asset_shared_member?(dir, asset)
        conn
          |> put_layout(false)
          |> send_download(
          {:file, FileServer.call(asset)},
            filename: asset.name,
            content_type: asset.filetype,
            disposition: :attachment,
            charset: "utf-8")
      end
    end

  defp color do
    Accounts.random_user().settings.default_color
  end
end
