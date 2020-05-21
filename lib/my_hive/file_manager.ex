defmodule MyHive.FileManager do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.FileManager.{
    Folder,
    FileAsset,
    SharedFolder,
    FileManagerHoover
  }
  alias MyHive.TreeManager

  def create_folders_from_tree(map, user_id, parent_id \\ nil) do
    Enum.each(map, fn({folder, subfolder}) ->
      {:ok, f} = create_folder(%{
        name: folder,
        folder_type: get_folder_type(subfolder),
        parent_id: parent_id,
        user_id: user_id
      })
      create_subfolder(subfolder, f.id, user_id)
    end)
  end

  defp get_folder_type(subfolder) do
    cond do
      is_nil(subfolder) -> "medico_legal_case"
      is_binary(subfolder) -> "medico_legal_case_#{subfolder}"
      is_map(subfolder) -> "medico_legal_case"
      is_list(subfolder) -> "medico_legal_case"
    end
  end


  defp assets(folder_id) do
    from f in FileAsset,
      where: f.folder_id == ^folder_id
  end

  def children(folder, %{order: :asc, column: :name}, is_admin) do
    folder
      |> role_based_children(is_admin)
      |> order_by([f], asc: f.name)
      |> Repo.all
  end

  def children(folder, %{order: :desc, column: :name}, is_admin) do
    folder
      |> role_based_children(is_admin)
      |> order_by([f], desc: f.name)
      |> Repo.all
  end

  def children(folder, %{order: :asc, column: :date}, is_admin) do
    folder
      |> role_based_children(is_admin)
      |> order_by([f], asc: f.updated_at)
      |> Repo.all
  end

  def children(folder, %{order: :desc, column: :date}, is_admin) do
    folder
      |> role_based_children(is_admin)
      |> order_by([f], desc: f.updated_at)
      |> Repo.all
  end
  def ordered_assets(folder_id, %{order: :asc, column: :name}) do
    folder_id |> assets |> order_by([f], asc: f.name)|> Repo.all
  end

  def ordered_assets(folder_id, %{order: :desc, column: :name}) do
    folder_id |>  assets |> order_by([f], desc: f.name)|> Repo.all
  end

  def ordered_assets(folder_id, %{order: :asc, column: :date}) do
    folder_id |> assets |> order_by([f], asc: f.updated_at)|> Repo.all
  end

  def ordered_assets(folder_id, %{order: :desc, column: :date}) do
    folder_id |> assets |> order_by([f], desc: f.updated_at)|> Repo.all
  end

  def role_based_children(folder, is_admin) do
    if is_admin do
      Folder.children(folder)
    else
      folder |> Folder.children() |> folder_type_not("medico_legal_case_admin")
    end
  end

  def get_folder!(id) do
    Repo.get(Folder, id) |> Repo.preload(:file_assets)
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

  defp create_subfolder(subfolder_name, _, _) when is_binary(subfolder_name) do
  end

  def change_to_converted_asset(asset, changes) do
    asset |> FileAsset.changeset(changes) |> Repo.update()
  end

  def update_doc_provider(user, doc_provider_id) do
    settings_changeset =
      user.settings |>
        Ecto.Changeset.change(%{document_provider_id: doc_provider_id})

    user
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_embed(:settings, settings_changeset)
    |> Repo.update()
  end

  def update_settings(user, settings_map) do
    changeset = for {key, val} <- settings_map, into: %{}, do: {String.to_atom(key), val}
    settings_changeset = user.settings
      |> Ecto.Changeset.change(changeset)
    user
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_embed(:settings, settings_changeset)
      |> Repo.update()
  end

  def update_file_asset(asset, changes) do
    asset
      |> FileAsset.changeset(changes)
      |> Repo.update()
  end

  def update_folder(folder, changes) do
    folder
      |> Folder.changeset(changes)
      |> Repo.update()
  end

  def delete_folder(folder_id) do
    folder_id |> get_folder!() |> Repo.delete()
  end

  def delete_file_asset(asset_id) do
    asset_id |> get_file_asset!() |> Repo.delete()
  end

  def delete_tree(folder_id) do
    case get_folder!(folder_id) do
      folder when is_map(folder) ->
        descds  = Folder.descendants(folder) |> Repo.all
        Enum.each(descds, fn subfolder ->
          delete_tree(subfolder.id)
        end)
        FileManagerHoover.delete_item(folder)
        _ -> nil
    end
  end

  def is_root(query) do
    query |> where([f], is_nil(f.parent_id))
  end

  def root_for_folder(folder_id) do
    folder_id
      |> get_folder!
      |> Folder.ancestors
      |> is_root
      |> Repo.one
  end

  def share_folder(folder_id, sharing_user_id, shared_user_id) do
    %SharedFolder{}
      |> SharedFolder.changeset(%{
        folder_id: folder_id,
        user_id: sharing_user_id,
        shared_user_id: shared_user_id})
      |> Repo.insert()
  end

  def unshare_folder(folder_id, sharing_user_id, shared_user_ids) do
    query = from f in SharedFolder,
      where: f.folder_id == ^folder_id
        and f.user_id == ^sharing_user_id
        and f.shared_user_id in ^shared_user_ids
    query |> Repo.delete_all()
  end

  def folder_type_not(query, folder_type) do
    query |> where([f], f.folder_type != ^folder_type)
  end
  def get_child_type(root_id, folder_type) do
    query = root_id
      |> get_folder!()
      |> Folder.children
      |> where([f], f.folder_type == ^folder_type)
    Repo.all(query)
  end
end
