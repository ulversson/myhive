defmodule MyHiveWeb.Plugs.FolderGuardianPlug do
  alias MyHive.FileManager
  alias MyHiveWeb.ApiFallbackController
  alias MyHive.FileManager.{
    FolderGuardian
  }

  def init(opts), do: opts

  def call(conn, _opts) do
    folder = FileManager.get_folder!(item_id(conn))
    case FolderGuardian.pass?(current_user(conn), folder) do
      :ok ->  conn
      :forbid -> conn |> ApiFallbackController.call({:error, :unauthorized})
    end
  end

  defp current_user(conn) do
    conn.private.guardian_default_resource
  end

  defp item_id(conn) do
    conn.params["parent_id"] || conn.params["id"]
  end

end
