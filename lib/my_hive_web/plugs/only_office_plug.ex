defmodule MyHiveWeb.Plugs.OnlyOfficePlug do
  import Plug.Conn
  import Phoenix.Controller
  alias MyHive.FileManager.OnlyOfficeJwt

  def init(opts), do: opts

  def call(conn, _opts) do
    token = only_office_token(conn)
    if token do
      map = OnlyOfficeJwt.decode(token)
      if map["payload"]["url"] =~ conn.request_path do
        conn
      else
        stop(conn)
      end
    else
      stop(conn)
    end
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
