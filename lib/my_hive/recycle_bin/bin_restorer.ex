defmodule MyHive.RecycleBin.BinRestorer do

  alias MyHive.{
    RecycleBin, FileManager, CaseManagement
  }

  def call(%{"id" => id, "type" => "file"}) do
    asset =  FileManager.get_file_asset!(id, true)
    restore_file(asset)
  end

  def call(%{"id" => id, "type" => "folder"}) do
    folder = FileManager.get_folder!(id, true)
    restore_folder(folder, folder_type(folder))
  end

  defp restore_file(asset) when is_nil(asset) == false do
    folder = FileManager.get_folder!(asset.folder_id)
    if is_nil(folder) do
      {:error, :restore_folder_not_found}
    else
      RecycleBin.restore_file(asset)
      true
    end
  end

  defp restore_file(asset) when is_nil(asset) == true do
    { :error, :restore_folder_not_found}
  end

  defp restore_folder(folder, folder_type)
    when folder_type == "medico_legal_case" or folder_type == "medico_legal_case_admin" or folder_type == "medico_legal_case_correspondence" do
      root = FileManager.root_for(folder.id)
      restore_case_folder(folder, root)
  end

  defp restore_folder(folder, folder_type) when folder_type == "shared_folder" or folder_type == "archive" do
    root = FileManager.root_for(folder.id)
    restore_non_case_folder(folder, root)
  end

  defp restore_folder(_, _) do
    {:error, :restore_error_no_root}
  end

  defp restore_case_folder(folder, root)  when is_nil(root) == false do
    mlc = CaseManagement.get_case_by_folder_id(root.id)
    if is_nil(mlc) do
      {:error, :restore_error_with_case}
    else
      successful_restore(folder)
    end
  end

  defp restore_case_folder(_folder, root) when is_nil(root) == true do
    {:error, :restore_error_with_case}
  end

  defp restore_non_case_folder(folder, root) when is_nil(root) == false do
    successful_restore(folder)
  end

  defp restore_non_case_folder(folder, root) when is_nil(root) == true do
    if is_nil(folder.parent_id) do
      successful_restore(folder)
    else
      {:error, :restore_error_no_root}
    end
  end

  defp successful_restore(folder) do
    RecycleBin.restore_folder(folder)
    true
  end


  defp folder_type(folder) when is_nil(folder) do
    nil
  end

  defp folder_type(folder) when is_map(folder) do
    folder.folder_type
  end

end
