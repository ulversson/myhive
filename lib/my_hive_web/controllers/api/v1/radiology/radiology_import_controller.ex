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

  def name(conn, %{"id" => import_id, "name" => name}) do 
    case Radiology.get_radiology_import!(import_id) do 
      nil -> 
        conn 
          |> put_status(422) 
          |> json(%{success: false, message: "Unable to update name"})
      rad_item ->
          Radiology.update_name(rad_item, name) 
          conn
            |> json(%{success: true, message: "ok"})
    end
  end

end
