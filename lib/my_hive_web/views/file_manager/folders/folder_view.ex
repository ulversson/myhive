defmodule MyHiveWeb.Api.V1.FileManager.FoldersView do
  use MyHiveWeb, :view
  alias MyHive.{FileManager, Stats}

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
      parent_id: folder.parent_id,
      ancestors: ancestors(folder, user_id),
      description: folder.description,
      assets: ordered_assets(user_id, folder.id, sort),
      not_viewed_file_count: not_viewed_file_count(folder, user_id),
      children: children(folder, user_id, %{column: column, order: order})
    }
  end

  def render("show_tree.json", %{folder: folder,
    column: column,
    order: order,
    user_id: user_id,
    roles: _roles}= sort) do
      %{
        id: folder.id,
        name: folder.name,
        updated: folder.updated_at,
        parent_id: folder.parent_id,
        description: folder.description,
        assets: ordered_assets(user_id, folder.id, sort),
        children: children_with_assets(folder, user_id, %{column: column, order: order})
      }
    end

  def render("child.json", %{folder: folder, user_id: user_id}) do
    %{
      id: folder.id,
      name: folder.name,
      parent_id: folder.parent_id,
      description: folder.description,
      updated: folder.updated_at,
      children: [],
      not_viewed_file_count: not_viewed_file_count(folder, user_id)
    }
  end

  defp not_viewed_file_count(folder, user_id) do
    folder = folder |> MyHive.Repo.preload(:file_assets)
    Enum.map(folder.file_assets, fn fa ->
      Stats.view_counts(user_id, fa.id)
    end)
    |> Enum.filter(fn x -> x == 0 end)
    |> Enum.count
  end

  defp ancestors(folder, user_id) do
    acstrs  = FileManager.Folder.ancestors(folder) |> MyHive.Repo.all
    render_many(acstrs, MyHiveWeb.Api.V1.FileManager.FoldersView,
      "child.json", as: :folder, user_id: user_id)
  end

  defp children(folder, user_id, %{order: order, column: column}) do
    order = %{order: String.to_atom(order), column: String.to_atom(column)}
    children = FileManager.children(folder, order)
    render_many(children, MyHiveWeb.Api.V1.FileManager.FoldersView,
      "child.json", as: :folder, user_id: user_id)
  end

  defp children_with_assets(folder, user_id, %{order: order, column: column}) do
    ordering = %{order: String.to_atom(order), column: String.to_atom(column)}
    children = FileManager.children(folder, ordering)
    render_many(children, MyHiveWeb.Api.V1.FileManager.FoldersView,
      "show_tree.json", as: :folder,
        column: column,
        order: order,
        roles: "",
        user_id: user_id)
  end

  defp ordered_assets(user_id, folder_id, %{order: order, column: column}) do
    order = %{order: String.to_atom(order), column: String.to_atom(column)}
    assets = FileManager.ordered_assets(folder_id, order)
    render_many(assets, MyHiveWeb.Api.V1.FileAssetView, "show.json",
      as: :asset, column: column, order: order, user_id: user_id)
  end
end
