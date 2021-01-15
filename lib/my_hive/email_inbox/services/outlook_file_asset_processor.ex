defmodule MyHive.EmailInbox.Services.OutlookFileAssetProcessor do

  alias MyHive.EmailInbox.Services.{
    OutlookAttachmentReader,
    OutlookFileAssetGenerator
  }

  def call(user_id, folder_id, message_id, attachment_ids) do
    attachments = user_id
      |> OutlookAttachmentReader.call(message_id)
      |> Enum.filter(fn attachment -> Enum.member?(attachment_ids, attachment["id"]) end)

    Enum.each(attachments, fn attachment ->
      OutlookFileAssetGenerator.call(user_id, folder_id, attachment)
    end)
  end

end
