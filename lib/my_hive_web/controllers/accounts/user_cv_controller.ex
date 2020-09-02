defmodule MyHiveWeb.Accounts.UserCvController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Accounts, CVFields
  }
  alias MyHive.FileManager.FileServer
  alias MyHive.Accounts.Services.{
    CvPdfRenderer, CvDocxRenderer
  }

  def cv(conn, %{"format" => "pdf", "user_id" => user_id}) do
    {:ok, pdf_path} = user_id
      |> Accounts.get_user!()
      |> CVFields.all_user_fields()
      |> CvPdfRenderer.call()
    conn|> send_download(
      {:file, pdf_path},
        filename: "CV.pdf",
        content_type: "application/pdf",
        disposition: :attachment,
        charset: "utf-8"
      )
  end

  def cv(conn, %{"format" => "word", "user_id" => user_id}) do
    {word_path, 0} = user_id
      |> Accounts.get_user!()
      |> CVFields.all_user_fields()
      |> CvDocxRenderer.call("/tmp/#{Timex.now |> Timex.to_unix}.docx")
    conn|> send_download(
      {:file, String.trim(word_path)},
        filename: "cv.docx",
        content_type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        disposition: :attachment,
        charset: "utf-8"
      )
  end

end
