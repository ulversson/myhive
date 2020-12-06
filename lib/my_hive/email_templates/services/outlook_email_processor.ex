defmodule MyHive.EmailTemplates.Services.OutlookEmailProcessor do

  alias MyHive.EmailTemplates.Services.{
    OutlookEmailSender, OutlookPdfRenderer,
    OutlookPdfUploader
  }

  def call(user_id, email, files) when is_nil(files) do
    OutlookEmailSender.call(user_id, email)
    OutlookPdfRenderer.call(email) |> OutlookPdfUploader.call(email)
  end

  def call(user_id, email, files) when is_list(files) do
    OutlookEmailSender.call(user_id, email, files)
    OutlookPdfRenderer.call(email) |> OutlookPdfUploader.call(email)
  end
end
