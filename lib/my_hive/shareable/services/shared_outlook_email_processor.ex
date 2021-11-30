defmodule MyHive.Shareable.SharedOutlookEmailProcessor do
  alias MyHive.EmailTemplates.Services.MicrosoftAuth
  alias MyHive.Shareable.SharedEmailPdfRenderer

  @base_uri "https://graph.microsoft.com"

  def call(user_id, dir, email)  do
    case MicrosoftAuth.update_credentials(user_id) do
      {:ok, cred} ->
        HTTPoison.post(
          post_uri(),
          message_from_template(dir, email),
          headers(cred)
        )
      {:error, changeset} ->
        changeset
    end
  end

  defp email_from_template(dir, email) do
    SharedEmailPdfRenderer.to_html(dir, email, false)
  end

  defp post_uri() do
    "#{@base_uri}/v1.0/me/sendMail"
  end

  defp message_from_template(dir, email) do
    %{
      "message" => %{
        "subject" => SharedEmailPdfRenderer.topic(dir),
        "importance" => "High",
        "hasAttachments" => true,
        "body" => %{
          "contentType" => "HTML",
          "content" => email_from_template(dir, email)
        },
        "toRecipients" => [
          %{
            "emailAddress" => %{
              "address" => email
            }
        }
        ],
       "bccRecipients" => []
      }
    } |> Jason.encode!()
  end

  defp headers(cred) do
    [
      {
        "Content-Type",
        "application/json"
      },
      {
        "Authorization",
        "Bearer #{cred.token}"
      }
    ]
  end

end
