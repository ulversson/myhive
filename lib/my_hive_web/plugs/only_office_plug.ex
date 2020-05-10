defmodule MyHiveWeb.Plugs.OnlyOfficePlug do
  import Plug.Conn
  import Phoenix.Controller
  alias MyHive.FileManager.OnlyOfficeJwt

  def init(opts), do: opts

  def call(conn, _opts) do
    token = only_office_token(conn)
    if token do
      map = OnlyOfficeJwt.decode(token)
      if can_download?(conn, map) || can_callback?(map) do
        conn
      else
        stop(conn)
      end
    else
      stop(conn)
    end
  end

  defp can_callback?(map) do
    Map.has_key?(map, "payload") && Map.has_key?(map["payload"], "key")
  end

  defp can_download?(conn, map) do
    (Map.has_key?(map, "payload")) && (Map.has_key?(map["payload"], "url")) && (map["payload"]["url"] =~ conn.request_path)
  end

  def only_office_token(conn) do
    Plug.Conn.get_req_header(conn, "authorization")
    |> List.first
    |> String.replace("Bearer ","")
  end

  def stop(conn) do
    conn
        |> redirect(to: "/login")
        |> halt()
  end

end
