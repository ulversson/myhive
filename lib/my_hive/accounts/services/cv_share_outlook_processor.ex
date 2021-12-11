defmodule MyHive.Shareable.Services.CvShareOutlookProcessor do
  alias MyHive.EmailTemplates.Services.MicrosoftAuth
  alias MyHive.Accounts.User

  @base_uri "https://graph.microsoft.com"

  def call(emails, sender, expert, pdf_path)  do
    case MicrosoftAuth.update_credentials(sender.id) do
      {:ok, cred} ->
        HTTPoison.post(
          post_uri(),
          message_from_template(emails, sender, expert, pdf_path),
          headers(cred)
        )
      {:error, changeset} ->
        changeset
    end
  end

  defp email_from_template(sender, expert) do
    Phoenix.View.render_to_string(MyHiveWeb.EmailView,
    "cv_share_email.html",
      conn: %Plug.Conn{},
      layout: {MyHiveWeb.LayoutView, "email.html"},
      sender: sender,
      expert: expert
    )
  end

  defp post_uri() do
    "#{@base_uri}/v1.0/me/sendMail"
  end

  defp message_from_template(emails, sender, expert, pdf_path) do
    %{size: size} = File.stat!(pdf_path)
    %{
      "message" => %{
        "subject" => "[my-hive] CV of #{User.field_by_name(expert, "Name").field_value}",
        "importance" => "High",
        "hasAttachments" => true,
        "body" => %{
          "contentType" => "HTML",
          "content" => email_from_template(sender, expert)
        },
        "toRecipients" => String.split(emails, ",")
          |> Enum.map(fn email ->
              %{
                "emailAddress" => %{
                  "address" => email
                }
            }
          end),
         "attachments" =>
          [%{
              "@odata.type" => "#microsoft.graph.fileAttachment",
              "name" => User.field_by_name(expert, "Name").field_value <> "'s CV.pdf",
              "isInline" => false,
              "id" => Ecto.UUID.generate(),
              "size" => size,
              "contentType" =>  "application/pdf",
              "contentBytes" => (File.read!(pdf_path) |> Base.encode64())
          }],
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
