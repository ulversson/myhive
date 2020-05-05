defmodule MyHiveWeb.Api.V1.Stats.ViewCounterView do
  use MyHiveWeb, :view

  def render("show.json", %{view_count: view_count}) do
    %{
      id: view_count.id,
      countable_id: view_count.countable_id,
      countable_type: view_count.countable_type,
      viewed_by: view_count.viewed_by
    }
  end
end
