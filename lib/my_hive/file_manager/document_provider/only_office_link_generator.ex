defmodule MyHive.FileManager.OnlyOfficeLinkGenerator do

  import MyHiveWeb.Router.Helpers
  def only_office_download_url(conn, asset) do
    document_provider_url(conn, :only_office_asset, conn.assigns.current_user.id, asset.id)
      |> make_https()
  end

  def callback_url(conn, asset) do
    document_provider_url(conn, :only_office_callback, asset.id)
      |> make_https()
  end

  defp make_https(url) do
    url |> String.replace(":4000", "")
  end

end
