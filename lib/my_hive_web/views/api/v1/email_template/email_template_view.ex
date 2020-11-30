defmodule MyHiveWeb.Api.V1.EmailTemplateView do
  use MyHiveWeb, :view

  def render("variables.json", %{
    template: _template,
    variables: variables
  }) do
    %{
      data: Enum.map(variables, &variable_json/1)
    }
  end

  defp variable_json(variable) do
    %{
      id: variable.id,
      name: variable.name,
      code: "{{#{variable.code}}}"
    }
  end
end
