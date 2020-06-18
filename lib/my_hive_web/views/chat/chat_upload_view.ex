defmodule MyHiveWeb.Api.V1.ChatUploadView do
  use MyHiveWeb, :view
  alias MyHive.FileManager.{
    Icons, FileTypeResolver
  }

  def render("attachment.json", %{attachment: attachment }) do
    %{
      data: attachment_json(attachment)
    }
  end

  defp attachment_json(attachment) do
    %{
      id: attachment.id,
      filetype: attachment.filetype,
      conversation_id: attachment.conversation_id,
      user_id: attachment.user_id,
      inserted_at: attachment.inserted_at,
      filename: attachment.filename,
      category: FileTypeResolver.call(attachment.filename),
      icon: Icons.get_from_filename(attachment.filename),
      size: attachment.size
    }
  end
end
