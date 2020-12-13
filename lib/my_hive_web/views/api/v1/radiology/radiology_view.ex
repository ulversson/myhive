defmodule MyHiveWeb.Api.V1.Radiology.RadiologyImportView do
  use MyHiveWeb, :view
  import MyHive.Radiology.RadiologyConfig
  alias MyHive.{CaseManagement, Repo}

  def render("show.json", %{imports: imports, mlc_id: mlc_id}) do
    f_import = List.first(imports)
    %{
      browser: browser_link(f_import, mlc_id),
      username: username(),
      password: password(),
      data: Enum.map(imports, &radiology_item/1)
    }
  end

  defp browser_link(f_import, _mlc_id) when f_import != nil do
    browser() <> "?patientName=#{name(f_import.medico_legal_case.patient.last_name)}*#{name(f_import.medico_legal_case.patient.first_name)}*"
  end

  defp browser_link(f_import, mlc_id) when is_nil(f_import) do
    mlc = CaseManagement.get_medico_legal_case!(mlc_id) |> Repo.preload(:patient)
    browser() <> "?patientName=#{name(mlc.patient.last_name)}*#{name(mlc.patient.first_name)}*"
  end

  defp name(name) do
    if String.contains?(name, " ") do
      name |> String.split() |> List.first |> String.upcase
    else
      String.upcase(name)
    end
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
