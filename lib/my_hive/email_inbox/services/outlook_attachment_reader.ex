defmodule MyHive.EmailInbox.Services.OutlookAttachmentReader do
  alias MyHive.EmailTemplates.Services.MicrosoftAuth

  @base_uri "https://graph.microsoft.com"

  def call(user_id, message_id) do
    case MicrosoftAuth.update_credentials(user_id) do
      {:ok, cred} ->
        request_url = request_url(message_id)
        try do
          res = HTTPoison.get!(request_url, headers(cred))
          Jason.decode!(res.body)["value"]
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

  defp request_url(message_id) do
    "#{@base_uri}/v1.0/me/mailFolders/Inbox/messages/#{message_id}/attachments"
  end
end
