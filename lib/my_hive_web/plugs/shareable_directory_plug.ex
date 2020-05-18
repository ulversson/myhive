defmodule MyHiveWeb.Plugs.ShareableDirectoryPlug do
  alias MyHive.Shareable
  alias MyHive.Shareable.Directory
  alias MyHiveWeb.FallbackController
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case Shareable.get_directory_by_token(conn.params["token"]) do
      {:ok, dir} ->
        if Directory.valid_for_email?(dir, conn.params["email"]) do
          conn |> Plug.Conn.put_session("dir", dir)
        else
          conn |> not_found()
        end
      {:error, :not_found} -> conn |> not_found()
      end
  end

  defp not_found(conn) do
    conn
      |> Plug.Conn.delete_session("dir")
      |> FallbackController.call({:error, :not_found})
      |> halt()
  end
end
