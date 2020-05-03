defmodule MyHive.FileManager.FileDownloader do

  alias MyHive.FileManager
  alias MyHive.FileManager.FileServer
  alias MyHive.FileManager.Folder
  alias MyHive.FileManager.FileAsset
  @main_storage "/tmp/processing_storage"

  def call(selected) do
    File.mkdir(@main_storage)
    storage = make_root()
    selected |> database_items
    |> Enum.each(fn
      item -> save_item(item, storage)
    end)
    files = create_files_list(storage)
    :zip.create(to_charlist(zip_file_path(storage)), files)
    zip_file_path(storage)
  end

  defp make_root() do
    p = Path.join(@main_storage, unix_timestamp())
    File.mkdir p
    p
  end

  defp zip_file_path(storage) do
    "#{storage}.zip"
  end

  defp save_item(%Folder{} = item, storage) do
    path = Path.join(storage, item.name)
    item = MyHive.Repo.preload(item, :file_assets)
    File.mkdir(path)
    children = item |> Folder.children |> MyHive.Repo.all
    Enum.each(children, fn child ->
      save_item(child, path)
    end)
    Enum.each(item.file_assets, fn asset ->
      save_item(asset, path)
    end)
  end

  defp save_item(%FileAsset{} = item, storage) do
    original_path = FileServer.call(item)
    File.copy(original_path, "#{storage}/#{item.name}")
  end

  defp unix_timestamp do
    DateTime.utc_now |> DateTime.to_unix |> Integer.to_string
  end

  defp database_items(selected) do

    selected
    |> Enum.map(fn x -> process_item(x) end)
  end

  defp process_item(%{"type" => "folder"} = item) do
    FileManager.get_folder!(item["id"])
  end

  defp process_item(%{"type" => "asset"} = item) do
    FileManager.get_file_asset!(item["id"])
  end

  defp create_files_list(path) do
    create_files_list(File.ls!(path), path)
  end

  defp create_files_list(paths, path) do
    create_files_list(paths, path, path)
  end

  defp create_files_list(paths, path, base_path) do
    Enum.reduce(paths, [],
      fn(filename, acc) ->
        filename_path = Path.join(path, filename)
        if File.dir?(filename_path) do
          acc ++ create_files_list(File.ls!(filename_path), filename_path, base_path)
        else
          filenm =
            if base_path,
              do: String.replace_leading(filename_path, base_path, ""),
              else: filename_path
          [{String.to_char_list(filenm), File.read!(filename_path)} | acc]
        end
      end
    )
  end

end
