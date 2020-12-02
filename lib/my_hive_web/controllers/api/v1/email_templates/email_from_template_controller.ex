defmodule MyHiveWeb.Api.V1.EmailFromTemplateController do
  use MyHiveWeb, :controller
  alias MyHive.EmailTemplates
  alias MyHiveWeb.FallbackController
  alias MyHive.EmailTemplates.EmailFromTemplate

  def create(conn, %{"email" => sent_email}) do
    user = conn.private.guardian_default_resource
    sent_email = EmailFromTemplate.variables_merge(sent_email)
    case EmailTemplates.create_email(sent_email, user) do
      {:ok, email} ->
        json(conn, %{
          "success" => true,
          "message" => "Email sent"
        })
      {:error, changeset} ->
        FallbackController.call(conn, {:error, changeset})
    end
  end
end
