defmodule MyHive.EmailTemplates.Services.OutlookEmailSender do
  alias MyHive.EmailTemplates
  alias MyHive.EmailTemplates.Services.MicrosoftAuth
  alias MyHive.EmailTemplates.EmailFromTemplate
  @base_uri "https://graph.microsoft.com"

  def call(user_id, email_from_template_id) do
    case MicrosoftAuth.update_credentials(user_id) do
      {:ok, cred} ->
        email_message =
          email_from_template_id
          |> EmailTemplates.get_email_from_template_by_id()
        HTTPoison.post(
          post_uri(),
          message_from_template(email_message),
          headers(cred)
        )
      {:error, changeset} ->
        changeset
    end
  end

  defp message_from_template(emessage) do
    %{
      "message" => %{
        "subject" => EmailFromTemplate.processed_subject(emessage),
        "importance" => "High",
        "body" => %{
          "contentType" => "HTML",
          "content" => emessage.email_body
        },
        "toRecipients" => (Enum.map(String.split(emessage.recipients, ","), fn rcpt ->
          %{
            "emailAddress" => %{
              "address" => rcpt
            }
        }
        end)),
        "bccRecipients" => (Enum.map(String.split(emessage.bcc_recipients, ","), fn rcpt ->
          %{
            "emailAddress" => %{
              "address" => rcpt
            }
        }
        end))
      }
    } |> Jason.encode!()
  end

  defp post_uri() do
    "#{@base_uri}/v1.0/me/sendMail"
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
