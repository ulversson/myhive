defmodule MyHive.EmailTemplates.Services.OutlookEmailSearcher do
  alias MyHive.EmailTemplates.Services.MicrosoftAuth
  alias MyHive.{
    Repo, CaseManagement
  }

  @base_uri "https://graph.microsoft.com"

  def call(user_id, mlc_id, start_date \\ nil) do
    case MicrosoftAuth.update_credentials(user_id) do
      {:ok, cred} ->
        query = query_for_mlc(mlc_id)
        request_url = search_uri(start_date)
        HTTPoison.get!(request_url, headers(cred))
      {:error, changeset} ->
        changeset
    end
  end

  def query_for_mlc(mlc_id) do
    mlc = mlc_id
      |> CaseManagement.get_medico_legal_case!()
      |> Repo.preload(:instructing_party)
    reference = if is_nil(mlc.instructing_party) , do: "", else:  mlc.instructing_party.reference
    query = [reference, mlc.file_reference, to_string(mlc_id)]
        |> Enum.filter(fn i ->  i != "" end)
        |> Enum.join("|")
    if String.starts_with?(query, "|"), do: String.slice(query, 1..-1), else:  query
  end

  defp headers(cred) do
    [
      {
        "Authorization",
        "Bearer #{cred.token}"
      }
    ]
  end

  defp search_uri(start_date) do
    uri = "#{@base_uri}/v1.0/me/messages"
    if is_nil(start_date) do
      uri
    else
      string_date = formatted_time(start_date)
      URI.encode("#{uri}?$filter=(receivedDateTime ge #{string_date}) and (fields/subject contains 669)")
    end
  end

  defp formatted_time(start_date) do
    (Timex.format(start_date, "{ISO:Extended:Z}") |> elem(1) |> String.split(".") |> List.first) <> "Z"
  end
end

#$filter=((receivedDateTime ge 2021-01-07T11:00:13Z) and (contains(subject, '669')))
#&filter=((fields/lookLookupId eq 71) and (fields/lookLookupId eq 53)
