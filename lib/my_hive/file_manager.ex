defmodule MyHive.FileManager do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.FileManager.Folder
  alias MyHive.FileManager.FileAsset
  alias MyHive.TreeManager
  def create_folders_from_tree(map, user_id, parent_id \\ nil) do
    Enum.each(map, fn({folder, subfolder}) ->
      {:ok, f} = create_folder(%{
        name: folder, folder_type: "medico_legal_case",
        parent_id: parent_id, user_id: user_id
      })
      create_subfolder(subfolder, f.id, user_id)
    end)
  end

  def children(folder, %{order: :asc, column: :name}) do
    folder |> Folder.children |> order_by([f], asc: f.name)|> Repo.all
  end

  def children(folder, %{order: :desc, column: :name}) do
    folder |> Folder.children |> order_by([f], desc: f.name)|> Repo.all
  end

  def children(folder, %{order: :asc, column: :date}) do
    folder |> Folder.children |> order_by([f], asc: f.updated_at)|> Repo.all
  end

  def children(folder, %{order: :desc, column: :date}) do
    folder |> Folder.children |> order_by([f], desc: f.updated_at)|> Repo.all
  end
  def get_folder!(id) do
    Repo.get!(Folder, id) |> Repo.preload(:file_assets)
  end
  def create_folder(attrs \\ %{}) do
    %Folder{}
    |> Folder.changeset(attrs)
    |> Repo.insert()
  end

  def create_asset(metadata) do
    %FileAsset{}
    |> FileAsset.changeset(metadata)
    |> Repo.insert()
  end

  def get_file_asset!(id) do
    Repo.get!(FileAsset, id)
  end

  defp create_subfolder(subfolder_name, parent_id, user_id) when is_list(subfolder_name) do
    Enum.each(subfolder_name, fn s_name ->
      TreeManager.create_child(s_name, parent_id, user_id, "medico_legal_case")
    end)
  end

  defp create_subfolder(subfolder_name, parent_id, user_id) when is_map(subfolder_name) do
    create_folders_from_tree(subfolder_name, user_id, parent_id)
  end

  defp create_subfolder(subfolder_name, _, _) when is_nil(subfolder_name) do
  end


end
