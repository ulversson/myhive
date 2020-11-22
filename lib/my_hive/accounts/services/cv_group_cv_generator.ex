defmodule MyHive.Accounts.GroupCVGenerator do
  @processing_storage "/tmp/processing_storage"

  alias MyHive.CVFields
  alias MyHive.Accounts.User
  alias MyHive.Accounts.Services.CvPdfRenderer
  import MyHive.ZipCommon

  def call() do
    storage_path = storage()
    Enum.each(users_with_cvs(), fn user ->
      {:ok, pdf_path} = CVFields.all_user_fields(user)
        |> CvPdfRenderer.call()
      if !File.exists?(storage_path) do
        File.mkdir_p(storage_path)
      end
      out = output_path(storage_path, user)
      File.copy(pdf_path, out)
    end)
    files = create_files_list(storage_path)
    :zip.create(to_charlist(zip_file_path(storage_path)), files)
    zip_file_path(storage_path)
  end

  defp users_with_cvs do
    CVFields.users_with_fields(3)
  end

  defp output_path(storage_path, user) do
    Path.join([storage_path, "#{User.name_for(user)}'s CV.pdf"])
  end

  defp storage() do
    to_string(Path.join(@processing_storage, to_string(Timex.now |> Timex.to_unix)))
  end

end
