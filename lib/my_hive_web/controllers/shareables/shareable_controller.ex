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
  alias MyHiveWeb.{
    FallbackController
  }

  def verify(conn, %{"token" => token, "email" => email}) do
    dir = get_session(conn, :dir)
    if Directory.valid_for_email?(dir, email) do
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
            encode: false,
            disposition: :attachment,
            charset: "utf-8"
        )
      end
    end

    def auth_partial(conn, %{"token" => _token}) do
      dir = get_session(conn, :dir)
        conn
          |> put_layout(false)
          |> render("auth_partial.html", dir: dir)
    end

    def authenticate(conn, %{"token" => _token, "email" => _,
      "authorization" => auth}) do
      dir = get_session(conn, :dir)
      case Shareable.authorize(dir, auth) do
        {:error, :invalid} ->
          conn
          |> put_status(422)
          |> json(%{"success" => false})
        {:error, _changeset} ->
          conn
          |> put_status(422)
          |> json(%{"success" => false})
        {:ok, _authorization} ->
          Shareable.grant_access(dir)
          ShareableDirectoryNotifier.call(dir)
          conn |>
            json(%{"success" => true})
      end
    end

  defp color do
    Accounts.random_user().settings.default_color
  end

  defp invalid_request(conn) do
    conn
      |> put_flash(:error, "Unauthorized request")
      |> redirect(to: "/")
  end

end
