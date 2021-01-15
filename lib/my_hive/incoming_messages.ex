defmodule MyHive.IncomingMessages do

  import Ecto.Query, warn: false
  alias MyHive.EmailInbox.{
    IncomingMessage,
    LastSearch
  }
  alias MyHive.Repo

  @emails_page_size 15

  def create_message(%{} = message, %{} = params) do
    %IncomingMessage{}
      |> IncomingMessage.changeset(%{
        message_id: message["id"],
        received_date_time: message["receivedDateTime"],
        has_attachments: message["hasAttachments"],
        internet_message_id: message["internetMessageId"],
        subject: message["subject"],
        body_preview: message["bodyPreview"],
        importance: message["importance"],
        parent_folder_id: message["parentFolderId"],
        conversation_id: message["conversationId"],
        content: message["body"]["content"],
        sender: message["sender"]["emailAddress"]["address"],
        sender_name: message["sender"]["emailAddress"]["name"],
        web_link: message["webLink"],
        user_id: params.user_id,
        medico_legal_case_id: params.mlc_id,
        provider_id: params.provider_id,
        recipients_name:  Enum.map(message["toRecipients"], fn rec -> rec["emailAddress"]["name"] end) |> Enum.join(","),
        to_recipients: Enum.map(message["toRecipients"], fn rec -> rec["emailAddress"]["address"] end) |> Enum.join(",")
      }) |> Repo.insert()
  end


  def last_search_date(provider_id, user_id, mlc_id) do
    query = from s in LastSearch,
      where: s.provider_id == ^provider_id
        and s.medico_legal_case_id == ^mlc_id
        and s.user_id == ^user_id,
      order_by: [{:desc, :last_searched_at}]
      Ecto.Query.first(query)
      |> Repo.one()
  end

  def timestamp_search(user_id, mlc_id, provider_id) do
    %LastSearch{}
      |> LastSearch.changeset(%{
        user_id: user_id,
        medico_legal_case_id: mlc_id,
        provider_id: provider_id,
        last_searched_at: Timex.now
      })
      |> Repo.insert()
  end

  def emails_for_case(page, user_id, mlc_id, provider_id) do
    IncomingMessage
      |> where([m], m.user_id == ^user_id)
      |> where([m], m.medico_legal_case_id == ^mlc_id)
      |> where([m], m.provider_id == ^provider_id)
      |> order_by(desc: :received_date_time)
      |> preload([:medico_legal_case, :provider, :user])
      |> Repo.paginate(page: page, page_size: @emails_page_size)
  end

  def find_by_id(email_id) do
    Repo.get_by!(IncomingMessage, id: email_id)
  end

  def delete_email(email_id) do
    email_id
      |> find_by_id()
      |> Repo.delete()
  end

  def mark_as_viewed!(email_id) do
    email_id
      |> find_by_id()
      |> IncomingMessage.changeset(%{viewed: true})
      |> Repo.update()
      |> elem(1)
  end

end
