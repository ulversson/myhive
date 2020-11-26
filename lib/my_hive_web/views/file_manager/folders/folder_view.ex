defmodule MyHiveWeb.Api.V1.FileManager.FoldersView do
  use MyHiveWeb, :view
  alias MyHiveWeb.Api.V1.FileManager.FoldersView
  alias MyHive.{
    FileManager, Stats, Repo
  }
  alias MyHive.FileManager.{
    FolderTypeResolver, Folder
  }

  def render("index.json", %{
    shared_by_me_folders: shared_by_me_folders,
    shared_by_others_folders: shared_by_others_folders,
    role: role}) do
    %{
      shared_by_me_folders: Enum.map(shared_by_me_folders, &folder_data/1),
      shared_by_others_folders: Enum.map(shared_by_others_folders, &folder_data/1),
      role: role
    }
  end

  def render("show.json", %{folder: folder,
    column: column,
    order: order,
    roles: roles,
    user_id: user_id} = sort) do
    %{
      id: folder.id,
      roles: roles,
      name: folder.name,
      updated: folder.updated_at,
      icon: FolderTypeResolver.icon(folder.folder_type),
      parent_id: folder.parent_id,
      trackable: folder.trackable,
      folder_type: folder.folder_type,
      ancestors: ancestors(folder, user_id),
      parent_name: Folder.parent_name(folder),
      description: folder.description,
      assets: ordered_assets(user_id, folder.id, sort),
      not_viewed_file_count: not_viewed_file_count(folder, user_id),
      children: children(folder, user_id, %{column: column, order: order}, is_admin?(roles))
    }
  end

  def render("show_tree.json", %{folder: folder,
    column: column,
    order: order,
    user_id: user_id,
    roles: roles}= sort) do
      %{
        id: folder.id,
        name: folder.name,
        updated: folder.updated_at,
        parent_id: folder.parent_id,
        description: folder.description,
        folder_type: folder.folder_type,
        trackable: folder.trackable,
        icon: FolderTypeResolver.icon(folder.folder_type),
        assets: ordered_assets(user_id, folder.id, sort),
        children: children_with_assets(folder, user_id,
          %{column: column, order: order}, roles)
    }
  end

  def render("move_tree.json", %{folder: folder}) do
    children = Folder.children(folder) |> Repo.all()
    %{
      id: folder.id,
      label: folder.name,
      icon: FolderTypeResolver.icon(folder.folder_type),
      isBranch: (length(children) > 0),
      children: render_many(children, FoldersView, "move_tree.json", as: :folder)
    }
  end

  def render("child.json", %{folder: folder, user_id: user_id}) do
    %{
      id: folder.id,
      name: folder.name,
      parent_id: folder.parent_id,
      description: folder.description,
      folder_type: folder.folder_type,
      updated: folder.updated_at,
      trackable: folder.trackable,
      icon: FolderTypeResolver.icon(folder.folder_type),
      children: [],
      not_viewed_file_count: not_viewed_file_count(folder, user_id)
    }
  end

  def folder_data(folder) do
    %{
      id: folder.id,
      name: folder.name,
      parent_id: folder.parent_id,
      description: folder.description,
      folder_type: folder.folder_type,
      trackable: folder.trackable,
      updated: folder.updated_at,
      icon: FolderTypeResolver.icon(folder.folder_type),
      children: [],
      user: user_json(folder.user),
      shared_with: Enum.map(folder.shared_with_users, &user_json/1),
      not_viewed_file_count: not_viewed_file_count(folder, folder.user_id)
    }
  end

  defp not_viewed_file_count(folder, user_id) do
    folder = folder |> MyHive.Repo.preload(:file_assets)
    Enum.map(folder.file_assets, fn fa ->
      if fa.deleted_at != nil do
        1
      else
        Stats.view_counts(user_id, fa.id)
      end
    end)
    |> Enum.filter(fn x -> x == 0 end)
    |> Enum.count
  end

  defp ancestors(folder, user_id) do
    acstrs  = FileManager.Folder.ancestors(folder) |> MyHive.Repo.all
    render_many(acstrs, FoldersView, "child.json", as: :folder, user_id: user_id)
  end

  defp children(folder, user_id, %{order: order, column: column}, is_admin) do
    order = %{order: String.to_atom(order), column: String.to_atom(column)}
    children = FileManager.children(folder, order, is_admin)
    render_many(children, FoldersView, "child.json", as: :folder, user_id: user_id)
  end

  defp children_with_assets(folder, user_id, %{order: order, column: column}, roles) do
    ordering = %{order: String.to_atom(order), column: String.to_atom(column)}
    children = FileManager.children(folder, ordering, is_admin?(roles))
    render_many(children, FoldersView,
      "show_tree.json", as: :folder,
        column: column,
        order: order,
        roles: roles,
        user_id: user_id)
  end

  defp ordered_assets(user_id, folder_id, %{order: order, column: column}) do
    order = %{order: String.to_atom(order), column: String.to_atom(column)}
    assets = FileManager.ordered_assets(folder_id, order)
    render_many(assets, MyHiveWeb.Api.V1.FileAssetView, "show.json",
      as: :asset, column: column, order: order, user_id: user_id)
  end

  defp is_admin?(roles) do
    Enum.member?(roles, "admin") || Enum.member?(roles, "super_admin")
  end

  defp user_json(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name
    }
  end
end
