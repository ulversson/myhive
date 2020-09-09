defmodule MyHiveWeb.Api.V1.Radiology.RadiologyImportController do
  use MyHiveWeb, :controller
  alias MyHive.Radiology
  action_fallback MyHiveWeb.ApiFallbackController
  def show(conn, %{"id" => case_id}) do
    imports = Radiology.imports_for_case(case_id)
    conn |> render("show.json", imports: imports, mlc_id: case_id)
  end

  def delete(conn, %{"id" => import_id}) do
    case Radiology.delete_import(import_id) do
      {:ok, deleted} ->
        File.rm(deleted.path)
        conn |> json(%{
          success: true,
          message: "Pacs archive removed",
          status: "ok"
        })
      {:error, error} ->
        conn |> json(%{success: false, message: error})
    end
  end
end
