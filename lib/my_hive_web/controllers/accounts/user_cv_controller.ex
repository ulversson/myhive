defmodule MyHiveWeb.Accounts.UserCvController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Accounts, CVFields
  }
  alias MyHive.Accounts.User
  alias MyHive.Accounts.GroupCVGenerator
  alias MyHive.Accounts.Services.{
    CvPdfRenderer, CvDocxRenderer
  }

  def cv(conn, %{"format" => "pdf", "user_id" => user_id}) do
    user = Accounts.get_user!(user_id)
    {:ok, pdf_path} = user_id
      |> Accounts.get_user!()
      |> CVFields.all_user_fields()
      |> CvPdfRenderer.call()
    conn|> send_download(
      {:file, pdf_path},
        filename: URI.encode("#{User.name_for(user)}.pdf"),
        encode: false,
        content_type: "application/pdf",
        disposition: :attachment,
        charset: "utf-8"
      )
  end

  def cv(conn, %{"format" => "word", "user_id" => user_id}) do
    user = Accounts.get_user!(user_id)
    {word_path, 0} = user_id
      |> Accounts.get_user!()
      |> CVFields.all_user_fields()
      |> CvDocxRenderer.call("/tmp/#{Timex.now |> Timex.to_unix}.docx")
    conn|> send_download(
      {:file, String.trim(word_path)},
        filename: URI.encode("#{User.name_for(user)}.docx"),
        encode: false,
        content_type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        disposition: :attachment,
        charset: "utf-8"
      )
  end

  def bundle(conn, _) do
    CVFields.remove_all_bundles()
    zip_file = GroupCVGenerator.call()
    CVFields.create_bundle(%{
      path: zip_file,
      generated_by: get_session(conn, :current_user_id)
    })
    conn |> send_download(
      {:file, zip_file},
      filename: "CVBundle.zip",
      encode: false,
      content_type: "application/zip",
      charset: "utf-8"
    )
  end

  def bundle_download(conn, _) do
    bundle = CVFields.last_bundle.path
    if File.exists?(bundle) do
      conn |> send_download(
        {:file, bundle},
        filename: "CV Bundle.zip",
        encode: false,
        content_type: "application/zip",
        charset: "utf-8"
      )
    else
      conn
        |> put_flash(:error, "File not found")
        |> redirect(to: "/users")
    end

  end

end
