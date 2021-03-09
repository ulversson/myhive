defmodule MyHiveWeb.Api.V1.GlossaryView do
  use MyHiveWeb, :view

  def render("index.json", %{items: items}) do
    %{
      data: Enum.map(items, &item_json/1)
    }
  end

  defp item_json(item) do
    %{
      id: item.id,
      name: item.name,
      short_name: item.short_name,
      description: item.description
    }
  end
end