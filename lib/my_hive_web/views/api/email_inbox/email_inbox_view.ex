defmodule MyHiveWeb.Api.V1.EmailInboxView do

  def render("index.json", %{email_page: page}) do
    %{
      data: %{
        page_number: page.page_number,
        page_size: page.page_size,
        total_entries: page.total_entries,
        total_pages: page.total_pages,
        entries: Enum.map(page.entries, fn eml -> render_entry(eml) end)
      }
    }
  end

  defp render_entry(eml) do
    %{
      id: eml.id,
      body_preview: eml.body_preview,
      content: eml.content,
      sender_name: eml.sender_name,
      recipients_name: eml.recipients_name,
      conversation_id: eml.conversation_id,
      web_link: eml.web_link,
      has_attachments: eml.has_attachments,
      importance: eml.importance,
      received_at: eml.received_date_time,
      sender: eml.sender,
      subject: eml.subject,
      to_receipients: eml.to_recipients,
      medico_legal_case_id: eml.medico_legal_case_id,
      provider_id: eml.provider_id,
      user_id: eml.user_id
    }
  end
end
