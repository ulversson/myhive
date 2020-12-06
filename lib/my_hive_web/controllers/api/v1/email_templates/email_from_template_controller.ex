defmodule MyHiveWeb.Api.V1.EmailFromTemplateController do
  use MyHiveWeb, :controller
  alias MyHive.EmailTemplates
  alias MyHiveWeb.FallbackController
  alias MyHive.EmailTemplates.EmailFromTemplate
  alias MyHive.EmailTemplates.Services.{
    OutlookEmailProcessor
  }

  def create(conn, %{"email" => sent_email} = params) do
    user = conn.private.guardian_default_resource
    sent_email = EmailFromTemplate.variables_merge(sent_email)
    case EmailTemplates.create_email(sent_email, user) do
      {:ok, email} ->
        OutlookEmailProcessor.call(user.id, email, params["files"])
        json(conn, %{
          "success" => true,
          "message" => "Email sent"
        })
      {:error, changeset} ->
        FallbackController.call(conn, {:error, changeset})
    end
  end
end
