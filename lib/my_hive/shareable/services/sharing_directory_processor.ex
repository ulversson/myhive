defmodule MyHive.Shareable.SharingDirectoryProcessor do
  use Ecto.Schema
  alias MyHive.{
    Repo, FileManager, Shareable
  }
  alias MyHive.Shareable.SharedEmailPdfRenderer
  alias MyHive.FileManager.AutoFileAssetUploader
  alias MyHive.CaseManagement.MedicoLegalCase
  alias MyHive.Supervisors.FileSharingSupervisor

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
      [:sharer, {:directory_file_assets, :file_asset},
      :directory_folders, :saas_account, {:medico_legal_case, :instructing_party}])
    Enum.each(emails, fn email ->
      FileSharingSupervisor.share_file(directory, email)
    end)
  end

  def upload_to_correspondence(directory, email) do
    {:ok, file_path} = SharedEmailPdfRenderer.call(directory, email)
    {:ok, folders} = MedicoLegalCase.correspondence_folders(directory.medico_legal_case)
    AutoFileAssetUploader.call(
      file_path,
      List.first(folders),
      "#{document_name()}")
    :ok
  end

  defp document_name() do
    "Item(s) disclosed - #{current_timestamp()}.pdf"
  end

  def current_timestamp() do
    {:ok, time} = Timex.now("Europe/London")
      |> Timex.format("%d.%m.%Y %H:%M@hours", :strftime)
    time
  end
end
