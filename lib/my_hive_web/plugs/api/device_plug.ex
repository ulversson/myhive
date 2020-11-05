defmodule MyHiveWeb.Plugs.DevicePlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    device_id = mobile_device_token(conn)
    conn |> assign(:device_id, device_id)
  end

  def mobile_device_token(conn) do
    Plug.Conn.get_req_header(conn, "x-device-id") |> List.first
  end

  def udid_token(conn) do
    Plug.Conn.get_req_header(conn, "x-d") |> List.first
  end

  def device_id(conn) do
    if Map.has_key?(conn, :device_id) do
      conn.assigns.device_id
    else
      nil
    end
  end

end
