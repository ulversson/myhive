defmodule MyHive.Accounts.JwtTokenVerifier do
  alias MyHive.Guardian
  alias MyHive.Accounts

  def call(jwt) when is_binary(jwt) and jwt != "" do
    case Guardian.decode_and_verify(jwt) do
      {:error, _} -> false
      {:ok, claims} -> Accounts.get_user!(claims["sub"])
    end
  end

  def call(jwt) when is_nil(jwt) do
    false
  end

  def call(jwt) when is_binary(jwt) and jwt == "" do
    false
  end
end
