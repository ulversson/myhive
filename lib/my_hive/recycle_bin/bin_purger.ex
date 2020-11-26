defmodule MyHive.RecycleBin.BinPurger do

  alias MyHive.RecycleBin
  alias MyHive.FileManager.FileManagerHoover

  def call() do
    all_items = RecycleBin.items_due_to_be_removed()
    remove_files(all_items.files)
    remove_folders(all_items.folders)
  end

  defp remove_files(files) do
    for file <- files do
      FileManagerHoover.hard_delete_item(file)
    end
  end

  defp remove_folders(folders) do
    for folder <- folders do
      FileManagerHoover.hard_delete_item(folder)
    end
  end

end
