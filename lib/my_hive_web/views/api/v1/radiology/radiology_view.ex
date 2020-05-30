defmodule MyHiveWeb.Api.V1.Radiology.RadiologyImportView do
  use MyHiveWeb, :view
  import MyHive.Radiology.RadiologyConfig

  def render("show.json", %{imports: imports}) do
    %{
      browser: browser_link(List.first(imports).medico_legal_case),
      username: username(),
      password: password(),
      data: Enum.map(imports, &radiology_item/1)
    }
  end

  defp browser_link(mlc) do
    browser() <> "?patientName=#{String.upcase(mlc.patient.last_name)}*"
  end

  defp radiology_item(rad_import) do
    %{
      id: rad_import.id,
      imported_at: rad_import.inserted_at,
      name: rad_import.name,
      description: rad_import.description,
      result: rad_import.result,
      error: rad_import.error
    }
  end
end
