defmodule MyHiveWeb.Radiology.RadiologyImportController do
  use MyHiveWeb, :controller
  alias MyHive.Radiology

  def download(conn, %{"id" => id}) do
    rad_import = Radiology.get_radiology_import!(id)
    conn |>
    send_download(
      {:file, rad_import.path},
      filename: rad_import.name,
      content_type: "application/zip",
      encode: false,
      disposition: :attachment,
      charset: "utf-8"
    )
  end
end
