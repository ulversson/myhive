defmodule MyHiveWeb.Accounts.UserCvController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Accounts, CVFields
  }
  alias MyHive.Accounts.Services.CvPdfRenderer

  def cv(conn, %{"user_id" => user_id, "format" => "pdf"}) do
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

  def cv(conn, %{"user_id" => user_id, "type" => "word"}) do
    CvPdfDownloader.call(user_id)
    conn|> send_download(
      {:file, CvPdfDownloader.pdf_path(user_id)},
        filename: "cv.pdf",
        content_type: "application/pdf",
        disposition: :attachment,
        charset: "utf-8"
      )
  end

end
