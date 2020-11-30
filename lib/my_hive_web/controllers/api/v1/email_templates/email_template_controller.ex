defmodule MyHiveWeb.Api.V1.EmailTemplateController do
  use MyHiveWeb, :controller
  alias MyHive.EmailTemplates

  def index(conn, %{"id" => template_id}) do
    template_with_vars = EmailTemplates.get_with_vars(template_id)
    conn |> render("variables.json",
      template: template_with_vars,
      variables: template_with_vars.template_variables
    )
  end

  def variables(conn, _) do
    conn |> render("variables.json",
      variables: EmailTemplates.all_variables()
    )
  end
end
