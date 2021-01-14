defmodule MyHiveWeb.Api.V1.EmailInboxController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Repo, Oauth2, IncomingMessages
  }
  alias MyHive.EmailInbox.Services.{
    OutlookSearchProcessor,
    EmailInboxHoover
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
        conn |> render("index.json", email_page: email_page)
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


end
