defmodule MyHiveWeb.MobileAppController do
  use MyHiveWeb, :controller
  plug :put_layout, false
  def ios(conn, _params) do
    conn
      |> put_resp_content_type("application/xml")
      |> render("ios.plist", root: MyHiveWeb.Endpoint.url())
  end
end
