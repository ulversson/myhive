defmodule MyHive.Shareable.SharingDirectoryProcessor do
  use Ecto.Schema
  alias MyHive.{
    Repo, FileManager, Shareable
  }
  def call(directory) do
    directory
    |> get_assets()
    |> save_relationships(directory)
    |> send_share_email()
  end

  defp get_assets(directory) do
    Enum.map(directory.files, fn file_id ->
      FileManager.get_file_asset!(file_id)
    end)
  end

  defp save_relationships(assets, directory) do
    Enum.each(assets, fn asset ->
      Shareable.create_dir_file_asset(%{
        directory_id: directory.id,
        file_asset_id: asset.id
      })
      Shareable.create_dir_folder(%{
        directory_id: directory.id,
        folder_id: asset.folder_id
      })
    end)
    directory
  end

  defp send_share_email(directory) do
    emails = String.split(directory.emails, ",")
    directory = Repo.preload(directory,
      [:sharer, {:directory_file_assets, :file_asset}, :directory_folders])
    Enum.each(emails, fn email ->
      MyHive.Emails.SharingDirectoryEmail.deliver(directory, email)
    end)
  end
end
