defmodule MyHive.Importers.SingleCaseImporter do

  import MyHive.JsonLoader
  alias MyHive.{
    CaseManagement, FileManager, Repo
  }
  alias MyHive.FileManager.Folder
  alias MyHive.FileManager.FileAssetAllocator
  alias MyHive.TreeManager


  def call(mlc_id) do
    old_id = mlc_id |> get_old_case_id()
    mlc = CaseManagement.get_medico_legal_case!(mlc_id)
    mlc_folder = get_folder(mlc.folder_id)
    mlc_folder_children = get_children(mlc_folder)
    descendants = get_descendants(mlc_folder)
    {:ok, case_data} = json_path("mlc-#{old_id}.json") |> get_json()
    folders = Enum.at(case_data, 0)["children"]
    Enum.each(folders, fn folder ->
      Enum.each(folder["children"], fn subfolder ->
        Enum.each(subfolder["assets"], fn child_asset ->
          do_asset(mlc_id, child_asset, descendants)
        end)
      end)
      Enum.each(folder["assets"], fn asset ->
        do_asset(mlc_id, asset, descendants)
      end)
    end)
  end

  def do_asset(mlc_id, asset, descendants) do
    asset_name = String.replace(asset["folder"],".","")
    my_hive2_folder = Enum.filter(descendants, fn f -> f.name == asset_name end) |> Enum.at(0)
    if (is_nil(my_hive2_folder)) do
      parent_name = asset["parent_folder"]
      parent_folder = Enum.filter(descendants, fn f -> f.name == parent_name end) |> Enum.at(0)
      {:ok, my_hive2_folder}  = TreeManager.create_child(asset_name, parent_folder.id, 1, "medico_legal_case")
      if (File.exists?(asset["disk_path"])) do
        map = FileAssetAllocator.call(asset["disk_path"], Path.basename(asset["disk_path"]))
        data = asset_data(mlc_id, my_hive2_folder, asset, map)
        FileManager.create_asset(data)
      end
    else
      if (File.exists?(asset["disk_path"])) do
        map = FileAssetAllocator.call(asset["disk_path"], Path.basename(asset["disk_path"]))
        data = asset_data(mlc_id, my_hive2_folder, asset, map)
        FileManager.create_asset(data)
      end
    end
  end

  def get_old_case_id(mlc_id) do
    mlc = mlc_id
      |> CaseManagement.get_medico_legal_case!()
    String.split(mlc.file_reference, "-")
      |> Enum.at(1)
      |> String.to_integer()
  end

  def get_folder(folder_id) do
    FileManager.get_folder!(folder_id)
      |> Repo.preload([:file_assets])
  end

  def get_children(folder) do
    FileManager.role_based_children(folder, true)
  end

  def get_descendants(folder) do
    Folder.descendants(folder) |> Repo.all()
  end

  def asset_data(mlc_id, folder, asset, map) do
    %{
      "filename" => asset["name"],
      "filetype" => asset["mime"],
      "folder_id" => folder.id,
      "medico_legal_case_id" => mlc_id,
      "name" => asset["name"],
      "path" => map.path,
      "size" => map.size,
      "type" => "video/quicktime",
      "user_id" => 1,
      "uid" => file_uid(map.path)
    }
  end

  defp file_uid(path) do
    Path.dirname(path) |> String.split("/") |> List.last
  end

end

MyHive.Importers.SingleCaseImporter.call(System.get_env("CASE_ID"))
