defmodule MyHiveWeb.Api.V1.SettingsView do
  use MyHiveWeb, :view

  def render("modules.json", %{modules: modules}) do
    Enum.map(modules, &module_json/1)
  end

  defp module_json(module) do
    %{
      id: module.application_module.id,
      name: module.application_module.name,
      code: module_code(module.application_module.short_name),
      description: module.application_module.description
    }
  end

  defp module_code(name) do
    String.replace(name, " ","_")
      |> String.downcase()
      |> String.replace("-","_")
  end
end
