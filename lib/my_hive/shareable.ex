defmodule MyHive.Shareable do
  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Shareable.{
    Directory,
    DirectoryFileAsset,
    DirectoryFolder,
    Authorization
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

  def remove_dir_folders(dir_id) do
    q = from df in DirectoryFolder,
      where: df.directory_id == ^dir_id
    Repo.delete_all(q)
  end

  def remove_dir_file_assets(dir_id) do
    q = from dfa in DirectoryFileAsset,
      where: dfa.directory_id == ^dir_id
    Repo.delete_all(q)
  end

  def get_old_shared_directories() do
    yest = yesterday()
    from d in Directory, where: d.expires <= ^yest
  end

  def authorize(directory, params) do
    params = Map.put(params, "shareable_directory_id", directory.id)
    changeset = %Authorization{} |> Authorization.changeset(params)
    if changeset.valid? do
      if changeset_match?(changeset, directory) do
        Repo.insert(changeset)
      else
        {:error, :invalid}
      end
    else
      {:error, changeset}
    end
  end

  def changeset_match?(changeset, dir) do
    Enum.member?(String.split(dir.emails,","), Ecto.Changeset.get_change(changeset, :email))
      && Ecto.Changeset.get_change(changeset, :first_name) == dir.first_name
      && Ecto.Changeset.get_change(changeset, :last_name) == dir.last_name
  end

  defp yesterday() do
    Timex.today |> Timex.shift(days: -3)
  end

  def shared_for_mlc(mlc_id) do
    q = from d in Directory,
    where: d.medico_legal_case_id == ^mlc_id,
    order_by: [{:desc, :inserted_at}],
    preload: [:folders, :file_assets, :sharer]
    Repo.all(q)
  end

  def resend(dir_id) do
    dir_id
    |> get_directory!()
    |> Directory.changeset(%{
      expires: (Timex.today |> Timex.shift(days: 3)),
      files: "fake"
    })
    |> Repo.update()
    |> elem(1)
  end

  def remove!(dir_id) do
    Repo.transaction(fn ->
      dir_id |> get_directory!()|> Repo.delete()
      remove_dir_file_assets(dir_id)
      remove_dir_folders(dir_id)
    end)
  end
end
