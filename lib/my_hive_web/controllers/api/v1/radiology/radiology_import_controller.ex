defmodule MyHiveWeb.Api.V1.Radiology.RadiologyImportController do
  use MyHiveWeb, :controller
  alias MyHive.Radiology
  action_fallback MyHiveWeb.ApiFallbackController
  def show(conn, %{"id" => case_id}) do
    imports = Radiology.imports_for_case(case_id)
    conn |> render("index.json", imports: imports)
  end
end
