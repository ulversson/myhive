defmodule MyHive.TreeManager do

  alias MyHive.{Repo,FileManager}

  def create_root(name) do
    FileManager.create_folder(%{name: name})
  end

  def create_child(name, parent_id, user_id, folder_type \\ "") do
    FileManager.create_folder(%{
      name: name,
      folder_type: folder_type,
      user_id: user_id,
      parent_id: parent_id})
  end

  def children(folder_id) do
    folder_id
      |> FileManager.get_folder!
      |> FileManager.Folder.children
      |> Repo.all
  end

  def ancestors(folder_id) do
    folder_id
      |> FileManager.get_folder!
      |> FileManager.Folder.ancestors
      |> Repo.all
  end

  def parent(folder_id) do
    folder_id
    |> FileManager.get_folder!
    |> FileManager.Folder.parent
    #|> Repo.first
  end

end
