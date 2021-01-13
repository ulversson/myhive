defmodule MyHive.EmailInbox.Services.OutlookSearchProcessor do
  alias MyHive.EmailTemplates.Services.OutlookEmailSearcher
  alias MyHive.{
    Oauth2,IncomingMessages, Repo
  }

  def call(user_id, mlc_id) do
    provider = Oauth2.find_by_name("Microsoft")
    start_date = determine_date(provider, user_id, mlc_id)
    case OutlookEmailSearcher.call(user_id, mlc_id, start_date) do
      messages ->
        Repo.transaction(fn ->
          Enum.map(messages, fn message ->
            IncomingMessages.create_message(message, %{
                user_id: user_id,
                mlc_id: mlc_id,
                provider_id: provider.id
              })
            |> elem(1)
          end)
          search_timestamp!(user_id, mlc_id, provider.id)
        end)
        _ -> search_timestamp!(user_id, mlc_id, provider.id)
    end
  end

  def search_timestamp!(user_id, mlc_id,  provider_id) do
    IncomingMessages.timestamp_search(user_id, mlc_id, provider_id)
  end

  defp determine_date(provider, user_id, mlc_id) do
    case IncomingMessages.last_search_date(provider.id, user_id, mlc_id) do
      nil -> nil
      last_search -> last_search.last_searched_at
    end
  end
end
