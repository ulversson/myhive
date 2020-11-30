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

  def render("variables.json", %{
    variables: variables
  }) do
    %{
      results: Enum.map(variables, &select2_variable_json/1)
    }
  end

  def render("templates.json", %{
    templates: templates
  }) do
    %{
      data: Enum.map(templates, &template_json/1)
    }
  end

  defp variable_json(variable) do
    %{
      id: variable.id,
      name: variable.name,
      code: "{{#{variable.code}}}",
      input_type: variable.input_type,
      description: variable.description
    }
  end

  defp select2_variable_json(variable) do
    %{
      id: variable.code,
      text: variable.name,
    }
  end

  defp template_json(template) do
    %{
      id: template.id,
      name: template.name,
      description: template.description
    }
  end

end
