defmodule MyHive.Shareable do
  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Shareable.{
    Directory,
    DirectoryFileAsset,
    DirectoryFolder
  }

  def create_shared_directory(changes, user_id) do
    map = Map.merge(%{"shared_by" => user_id}, changes)
    %Directory{}
      |> Directory.changeset(map)
      |> Repo.insert()
  end

  def create_dir_file_asset(changes) do
    %DirectoryFileAsset{}
      |> DirectoryFileAsset.changeset(changes)
      |> Repo.insert()
  end

  def create_dir_folder(changes) do
    %DirectoryFolder{}
      |> DirectoryFolder.changeset(changes)
      |> Repo.insert()
  end
end
