defmodule MyHiveWeb.Api.V1.FileManager.RecycleBinController do
  use MyHiveWeb, :controller
  alias MyHive.RecycleBin

  def index(conn, _params) do
    user_id = conn.private.guardian_default_resource.id
    assets = RecycleBin.deleted_file_assets
    conn |> render("bin.json", %{
      assets: assets,
      user_id: user_id
    })
  end

end
