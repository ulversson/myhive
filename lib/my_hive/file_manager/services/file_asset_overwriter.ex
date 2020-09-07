defmodule MyHive.FileManager.FileAssetOverwriter do
  import MyHive.Utils.MapUtils
  import MyHive.FileManager, only: [
    file_by_name_and_folder_id: 2,
    update_file_asset: 2
  ]
  alias MyHive.FileManager.{
    FileServer
  }

  def call(file_map) do
    updated = file_map
      |> new_file_map() |> update_file_in_path()
    update_file_asset(updated.existing, updated.map)
  end

  def overwrite?(%{"overwrite" => overwrite} = params, filename) do
    files_to_overwrite = overwrite |> String.split(",")
    if Enum.member?(files_to_overwrite, filename) do
      case file_by_name_and_folder_id(filename, params["folder_id"]) do
        nil -> false
        _ -> true
      end
    else
      false
    end
  end

  def overwrite?(_params, _filename) do
    false
  end

  defp new_file_map(file_map) do
    file_map |> keys_to_atoms()
  end

  defp existing_asset(file_map) do
    file_by_name_and_folder_id(
      new_file_map(file_map).name,
      new_file_map(file_map).folder_id
    )
  end

  defp new_file_path(file_map) do
    file_map
      |> new_file_map()
      |> FileServer.call()
  end

  defp existing_file_path(file_map) do
    file_map
      |> existing_asset()
      |> FileServer.call()
  end

  defp updated_path(file_map) do
    file_map
      |> new_file_map()
      |> Map.put(:path, existing_file_path(file_map))
  end

  defp update_file_in_path(file_map)  do
    File.copy(new_file_path(file_map), existing_file_path(file_map))
    %{
      existing: existing_asset(file_map),
      map: updated_path(file_map)
    }
  end

end
