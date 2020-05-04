defmodule MyHiveWeb.Api.V1.Stats.ViewCountsController do
  use MyHiveWeb, :controller
  action_fallback MyHiveWeb.ApiFallbackController
  alias MyHive.Stats
  def create(conn, %{"id" => id, "type" => type}) do
    current_user = Guardian.Plug.current_resource(conn)
    Stats.add_view_count(%{
      viewed_by: current_user,
      countable_id: id,
      countable_type: type
    })
    conn |> json(%{"success" => true})
  end

end
