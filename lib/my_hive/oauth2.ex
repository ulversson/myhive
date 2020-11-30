defmodule MyHive.Oauth2 do

  alias MyHive.Repo
  import Ecto.Query, warn: false
  alias MyHive.Oauth2.Provider
  alias MyHive.Accounts.OAuth2Credential

  def all_providers() do
    query = from p in Provider,
      where: p.enabled == true,
      select: [:name, :icon, :id]
    Repo.all(query)
  end

  def add_provider(changeset = %{}) do
    %Provider{}
      |> Provider.changeset(changeset)
      |> Repo.insert()
  end

  def find_by_name(provider) do
    Repo.get_by(Provider, name: provider)
  end

  def credential_from_response(response = %{}) do
    %OAuth2Credential{}
      |> OAuth2Credential.changeset(response)
      |> Repo.insert()
  end

  defp providers_for(user_id) do
    from c in OAuth2Credential,
      where: c.user_id == ^user_id,
      order_by: [desc: c.id],
      limit: 1
  end

  defp providers_for(user_id, provider_id) do
    from c in OAuth2Credential,
      where: c.user_id == ^user_id
        and c.provider_id == ^provider_id
  end

  def last_credential_for(user_id) do
    user_id |> providers_for() |> Repo.one()
  end

  def authenticated?(user_id, provider_id) do
    query =
      user_id
        |> providers_for(provider_id)

    case Repo.one(query) do
      nil -> false
      _prov -> true
    end
  end

  def withdraw(user_id, provider_name) do
    provider = find_by_name(provider_name)
    providers_query = providers_for(user_id, provider.id)
    Repo.delete_all(providers_query)
  end


end
