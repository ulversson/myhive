defmodule MyHive.FileManager.FileManagerCommon do
  alias MyHive.FileManager

  def database_items(selected) do
    selected |> Enum.map(fn x -> process_item(x) end)
  end

  def process_item(%{"type" => "folder"} = item) do
    FileManager.get_folder!(item["id"], true)
  end

  def process_item(%{"type" => "asset"} = item) do
    FileManager.get_file_asset!(item["id"], true)
  end

end
