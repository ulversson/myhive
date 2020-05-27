defmodule MyHive.Radiology.RadiologyImporter do
  alias MyHive.FileManager.FileServer
  alias MyHive.FileManager.FileManagerHoover
  alias MyHive.Radiology
  alias MyHive.Radiology.{
    ZipExtractor,
    DicomUploader,
    RadiologyNotifier
  }

  def call(file_asset, "application/zip", file_map) do
    file_asset |> process_asset(file_map)
  end

  def call(_,_,_) do
  end

  defp process_asset(asset, file_map) do
    asset_path = FileServer.call(asset)
      |> copy_file
      |> String.to_charlist
    extract_path = output_path(asset, asset_path)
    with {:ok, _content} <- ZipExtractor.call(asset_path, extract_path),
         {:ok, res} <- DicomUploader.call(to_string(extract_path)),
        {:ok, rad_import} <- Radiology.radiology_import_from(asset, file_map["medico_legal_case_id"]) do
        Radiology.update_result(rad_import, res)
        cleanup(asset)
        FileManagerHoover.delete_item(asset)
        RadiologyNotifier.call(file_map, :success)
    else
      {:error, :not_dicom} ->
        cleanup(asset)
      {:error, error} ->
        Radiology.radiology_import_with_error(
            asset,
            file_map["medico_legal_case_id"],
            to_string(error))
        cleanup(asset)
        FileManagerHoover.delete_item(asset)
        RadiologyNotifier.call(file_map, :failure)
    end
  end

  defp copy_file(asset_path) do
    zip_path = asset_path <> ".zip"
    File.cp(asset_path, zip_path)
    zip_path
  end

  defp cleanup(asset) do
    asset_path = FileServer.call(asset)
    extract_path = output_path(asset, asset_path)

    File.rm_rf(extract_path)
  end

  defp output_path(asset, asset_path) do
    asset_path = Path.join(asset_path, "extracted")
    |> String.replace(".zip", "") |> String.replace(asset.uid, "")
    File.mkdir_p(asset_path)
    String.to_charlist(asset_path)
  end

end
