defmodule MyHive.EmailTemplates.Services.OutlookEmailSender do
  alias MyHive.EmailTemplates.Services.MicrosoftAuth
  alias MyHive.EmailTemplates.EmailFromTemplate
  alias MyHive.FileManager
  alias MyHive.FileManager.FileServer
  alias MyHive.Encryption.FileAssetDecryptionProcessor

  @base_uri "https://graph.microsoft.com"

  def call(user_id, email_from_template)  do
    case MicrosoftAuth.update_credentials(user_id) do
      {:ok, cred} ->
        HTTPoison.post(
          post_uri(),
          message_from_template(email_from_template),
          headers(cred)
        )
      {:error, changeset} ->
        changeset
    end
  end

  def call(user_id, email_from_template, files) when is_list(files) do
    case MicrosoftAuth.update_credentials(user_id) do
      {:ok, cred} ->
        HTTPoison.post(
          post_uri(),
          message_from_template(email_from_template, files),
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
        "bccRecipients" => bcc_recipients(emessage.bcc_recipients)
      }
    } |> Jason.encode!()
  end

  defp message_from_template(emessage, files) do
    %{
      "message" => %{
        "subject" => EmailFromTemplate.processed_subject(emessage),
        "importance" => "High",
        "hasAttachments" => true,
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
        "attachments" => (Enum.map(files, fn file_id ->
          file_asset = FileManager.get_file_asset!(file_id)
          if file_asset.file_encrypted do
            FileAssetDecryptionProcessor.call(file_asset)
          end
          path = FileServer.call(file_asset)
          %{
              "@odata.type" => "#microsoft.graph.fileAttachment",
              "name" => file_asset.name,
              "isInline" => false,
              "id" => file_asset.id,
              "size" => file_asset.size,
              "contentType" =>  file_asset.filetype,
              "contentBytes" => (File.read!(path) |> Base.encode64())
          }
        end)),
       "bccRecipients" => bcc_recipients(emessage.bcc_recipients)
      }
    } |> Jason.encode!()
  end

  defp post_uri() do
    "#{@base_uri}/v1.0/me/sendMail"
  end

  defp bcc_recipients(recipients) when is_nil(recipients) do
    []
  end

  defp bcc_recipients(recipients) when is_nil(recipients) == false do
    (Enum.map(String.split(recipients, ","), fn rcpt ->
      %{
        "emailAddress" => %{
          "address" => rcpt
        }
    }end))
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
