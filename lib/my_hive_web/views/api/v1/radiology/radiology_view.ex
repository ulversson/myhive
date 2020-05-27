defmodule MyHiveWeb.Api.V1.Radiology.RadiologyImportView do
  use MyHiveWeb, :view

  def render("index.json", %{imports: imports}) do
    Enum.map(imports, &radiology_item/1)
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
