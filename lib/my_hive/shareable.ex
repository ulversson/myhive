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

  def get_directory_by_token(token) do
    case Repo.get_by(Directory, token: token) do
      nil ->
        {:error, :not_found}
      dir ->
        {:ok, dir}
    end
  end

  def preload_all(directory) do
    Repo.preload(directory, [
      :sharer,
      {:directory_folders, :folder},
      {:directory_file_assets, :file_asset},
      :medico_legal_case,
      :saas_account
    ])
  end

  def grant_access(directory) do
    directory
    |> Ecto.Changeset.change(%{approved: true})
    |> Repo.update()
  end

  def get_directory!(id) do
    Repo.get_by(Directory, id: id)
  end

  def get_old_shared_directories() do
    yest = yesterday()
    from d in Directory, where: d.expires <= ^yest
  end
  defp yesterday() do
    Timex.today |> Timex.shift(days: -1)
  end
end
