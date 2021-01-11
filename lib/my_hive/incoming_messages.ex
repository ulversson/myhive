defmodule MyHive.IncomingMessages do

  import Ecto.Query, warn: false
  alias MyHive.EmailInbox.IncomingMessage
  alias MyHive.Repo

  def message_from_api(%{} = message) do
    %IncomingMessage{}
      |> IncomingMessage.changeset(%{
        message_id: message["id"],
        receved_date_time: message["receivedDateTime"],
        has_attachments: message["hasAttachments"],
        internet_message_id: message["internetMessageId"],
        subject: message["subject"],
        body_preview: message["bodyPreview"],
        importance: message["importance"],
        parent_folder_id: message["parentFolderId"],
        conversation_id: message["conversationId"],
        content: message["body"]["content"],
        sender: message["sender"]["emailAddress"]["address"],
        web_link: message["webLink"],
        to_recipients: Enum.map(message["toRecipients"], fn rec -> rec["emailAddress"]["address"] end) |> Enum.join(",")
      }) |> Repo.insert()
  end

end
