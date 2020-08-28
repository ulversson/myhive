defmodule MyHive.Accounts.CvPdfDownloader do
  import Librex
  alias MyHive.{Repo, Accounts}
  alias MyHive.FileManager.FileServer

  def call(user_id) do
    user_id
      |> pdf_user()
      |> word_path()
      |> convert(pdf_path(user_id))
  end

  def pdf_user(user_id) do
    user_id
      |> Accounts.get_user!()
      |> Repo.preload(:cv)
  end

  def pdf_path(user) when is_map(user) do
    String.replace(word_path(user), "docx", "pdf")
  end

  def pdf_path(user_id) when is_binary(user_id) do
    user_id
      |> pdf_user()
      |> word_path()
      |> String.replace("docx", "pdf")
  end

  def word_path(user) do
    FileServer.call(user.cv)
  end

end
