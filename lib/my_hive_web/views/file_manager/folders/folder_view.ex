defmodule MyHiveWeb.Api.V1.FileManager.FoldersView do
  use MyHiveWeb, :view
  alias MyHive.FileManager

  def render("show.json", %{folder: folder}) do
    %{
      id: folder.id,
      name: folder.name,
      updated: folder.updated_at,
      children: children(folder)
    }
  end

  def render("child.json", %{folder: folder}) do
    %{
      id: folder.id,
      name: folder.name,
      updated: folder.updated_at,
      children: []
    }
  end

  defp children(folder) do
    children = FileManager.children(folder, %{order: :asc, column: :name})
    render_many(children, MyHiveWeb.Api.V1.FileManager.FoldersView, "child.json", as: :folder)
  end
end
