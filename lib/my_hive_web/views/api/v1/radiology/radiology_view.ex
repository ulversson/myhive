defmodule MyHiveWeb.Api.V1.Radiology.RadiologyImportView do
  use MyHiveWeb, :view
  import MyHive.Radiology.RadiologyConfig

  def render("show.json", %{imports: imports}) do
    f_import = List.first(imports)
    %{
      browser: browser_link(f_import),
      username: username(),
      password: password(),
      data: Enum.map(imports, &radiology_item/1)
    }
  end

  defp browser_link(f_import) when f_import != nil do
    browser() <> "?patientName=#{String.upcase(f_import.medico_legal_case.patient.last_name)}*#{String.upcase(f_import.medico_legal_case.patient.first_name)}*"
  end

  defp browser_link(f_import) when is_nil(f_import) do
    ""
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
