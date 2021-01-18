defmodule MyHiveWeb.Api.V1.EmailInboxController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Repo, Oauth2, IncomingMessages
  }
  alias MyHive.EmailInbox.Services.{
    OutlookSearchProcessor,
    EmailInboxHoover,
    OutlookAttachmentReader,
    OutlookFileAssetProcessor,
    OutlookEmailContentUploader
  }

  def providers(conn, _) do
    user = conn.private.guardian_default_resource
    providers = Oauth2.providers_for(user.id)
      |> Repo.all()
    conn |> json(%{
      providers: Enum.map(providers, fn prov -> prov.provider end) |> List.flatten
    })
  end

  def index(conn, %{"provider" => provider_name, "id" => id, "page" => page}) do
    case Oauth2.find_by_name(provider_name) do
      nil -> conn |> json(%{
        data: %{}
      })
      provider ->
        user = conn.private.guardian_default_resource
        email_page = IncomingMessages.emails_for_case(page, user.id, id, provider.id)
        conn |> render("index.json", email_page: email_page, user: user)
    end
  end

  def index(conn, _) do
    conn |> json(%{
      data: %{}
    })
  end

  def refresh(conn, %{"id" => id}) do
    user = conn.private.guardian_default_resource
    OutlookSearchProcessor.call(user.id, id)
    conn |> json(%{
      success: true,
      message: "ok"
    })
  end

  def delete(conn, %{"ids" => ids}) do
    EmailInboxHoover.call(ids)
    conn |> json(%{
      success: true,
      message: "Email has been removed",
      status: "ok"
    })
  end

  def view(conn, %{"id" => id}) do
    IncomingMessages.mark_as_viewed!(id)
    conn |> json(%{
      success: true,
      status: "ok"
    })
  end

  def attachments(conn, %{"message_id" => message_id}) do
    user = conn.private.guardian_default_resource
    conn |> json(%{
      data: OutlookAttachmentReader.call(user.id, message_id)
    })
  end

  def save_attachments(conn, %{
      "message_id" => message_id,
      "folder_id" => folder_id,
      "attachment_ids" => ids}) do
        user = conn.private.guardian_default_resource
      OutlookFileAssetProcessor.call(user.id, folder_id, message_id, ids)
      conn |> json(%{
        success: true,
        status: "ok"
      })
  end

  def save_content(conn, %{
    "message_id" => message_id,
    "folder_id" => folder_id
    }) do
    OutlookEmailContentUploader.call(message_id, folder_id)
    conn |> json(%{
      success: true,
      status: "ok"
    })
  end

end
