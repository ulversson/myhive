defmodule MyHive.EmailTemplates.Services.OutlookEmailSearcher do
  alias MyHive.EmailTemplates.Services.MicrosoftAuth
  alias MyHive.{
    Repo, CaseManagement
  }

  @base_uri "https://graph.microsoft.com"

  def call(user_id, mlc_id, start_date \\ nil) do
    case MicrosoftAuth.update_credentials(user_id) do
      {:ok, cred} ->
        mlc = CaseManagement.get_medico_legal_case!(mlc_id) |> Repo.preload(:instructing_party)
        request_url = search_uri(start_date, mlc, mlc.instructing_party.reference)
        try do
          res = HTTPoison.get!(request_url, headers(cred))
          dt = Jason.decode!(res.body)["value"]
        catch
         _  ->
          []
        end
      {:error, changeset} ->
        changeset
    end
  end

  defp headers(cred) do
    [
      {
        "Authorization",
        "Bearer #{cred.token}"
      }
    ]
  end

  defp search_uri(start_date, mlc, other_ref) when is_binary(other_ref) do
    uri = "#{@base_uri}/v1.0/me/mailFolders/Inbox/messages"
    if is_nil(start_date) do
      URI.encode("#{uri}?$filter=((contains(subject, '#{mlc.file_reference}')  or (contains(subject, '#{other_ref}'))    ))")
    else
      string_date = formatted_time(start_date)
      URI.encode("#{uri}?$filter=((receivedDateTime ge #{string_date}) and ((contains(subject, '#{mlc.file_reference}'))  or (contains(subject, '#{other_ref}'))  ))")
    end
  end


  defp search_uri(start_date, mlc, other_ref) when is_nil(other_ref)  do
    uri = "#{@base_uri}/v1.0/me/mailFolders/Inbox/messages"
    if is_nil(start_date) do
      URI.encode("#{uri}?$filter=((contains(subject, '#{mlc.file_reference}') ))")
    else
      string_date = formatted_time(start_date)
      URI.encode("#{uri}?$filter=((receivedDateTime ge #{string_date}) and ((contains(subject, '#{mlc.file_reference}')) ))")
    end
  end

  defp formatted_time(start_date) do
    start_date |> Timex.format("{ISO:Extended:Z}") |> elem(1)
  end
end
