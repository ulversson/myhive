defmodule MyHiveWeb.Api.V1.FileManager.FoldersView do
  use MyHiveWeb, :view
  alias MyHive.FileManager

  def render("show.json", %{folder: folder, column: column, order: order}) do
    %{
      id: folder.id,
      name: folder.name,
      updated: folder.updated_at,
      parent_id: folder.parent_id,
      description: folder.description,
      assets: render_many(folder.file_assets,
        MyHiveWeb.Api.V1.FileAssetView, "show.json",
        as: :asset, column: column, order: order),
      children: children(folder, %{column: column, order: order})
    }
  end

  def render("child.json", %{folder: folder}) do
    %{
      id: folder.id,
      name: folder.name,
      parent_id: folder.parent_id,
      description: folder.description,
      updated: folder.updated_at,
      children: []
    }
  end

  defp children(folder, %{order: order, column: column}) do
    order = %{order: String.to_atom(order), column: String.to_atom(column)}
    children = FileManager.children(folder, order)
    render_many(children, MyHiveWeb.Api.V1.FileManager.FoldersView, "child.json", as: :folder)
  end
end
