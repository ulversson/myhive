defmodule MyHive.Oauth2.Microsoft.UserFromAuth do
  require Logger
  require Poison

  alias Ueberauth.Auth
  alias MyHive.Oauth2

  def find_or_create(%Auth{provider: :identity} = auth, user_id, provider) do
    case validate_pass(auth.credentials) do
      :ok ->
        {:ok, basic_info(auth, user_id, provider)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_or_create(%Auth{} = auth, user_id, provider) do
    {:ok, basic_info(auth, user_id, provider)}
  end

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # facebook does it this way
  defp avatar_from_auth(%{info: %{image: image}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    Logger.warn("#{auth.provider} needs to find an avatar URL!")
    Logger.debug(Poison.encode!(auth))
    nil
  end

  defp basic_info(auth, user_id, provider) do
    response_data = %{
      id: auth.uid,
      user_id: user_id,
      provider_id: Oauth2.find_by_name(provider).id,
      name: name_from_auth(auth),
      avatar: avatar_from_auth(auth),
      email: auth.info.email,
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      expires_at: Timex.from_unix(auth.credentials.expires_at)
    }
    Oauth2.credential_from_response(response_data)
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end

  defp validate_pass(%{other: %{password: ""}}) do
    {:error, "Password required"}
  end

  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
    :ok
  end

  defp validate_pass(%{other: %{password: _}}) do
    {:error, "Passwords do not match"}
  end

  defp validate_pass(_), do: {:error, "Password Required"}
end
