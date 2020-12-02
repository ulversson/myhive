defmodule MyHive.EmailTemplates.Services.MicrosoftAuth do

  alias MyHive.Oauth2

  @base_url "https://login.microsoftonline.com"
  @client_id Application.get_env(:ueberauth, Ueberauth.Strategy.Microsoft.OAuth)[:client_id]
  @client_secret Application.get_env(:ueberauth, Ueberauth.Strategy.Microsoft.OAuth)[:client_secret]

  def auth_client(user_id) do
    credentials = Oauth2.last_credential_for(user_id)
    OAuth2.Client.new([
      strategy: OAuth2.Strategy.Refresh, #default
      client_id: @client_id,
      client_secret: @client_secret,
      site: @base_url,
      token_url: "/common/oauth2/v2.0/token",
      request_opts: [
        {"refresh_token", credentials.refresh_token}
      ],
      ref: to_string(user_id),
      params: %{"refresh_token" => credentials.refresh_token}
    ])
  end

  def authentication_response(user_id) do
    user_id
      |> auth_client()
      |> OAuth2.Client.get_token!
  end

  def update_credentials(user_id) do
    credentials = Oauth2.last_credential_for(user_id)
    case authentication_response(user_id) do
      client ->
        refresh = client.request_opts
        {:ok, access} = Jason.decode(client.token.access_token)
        refresh_token = refresh |> List.first |> elem(1)
        Oauth2.update_credentials(credentials, %{
          token: access["access_token"],
          refresh_token: refresh_token
        })
    end
  end

end
