defmodule MyHiveWeb.Api.V1.TimelineView do
  use MyHiveWeb, :view
  alias MyHiveWeb.MedicoLegalCaseView

  def render("statuses.json", %{statuses: statuses}) do
    render_one(statuses, MedicoLegalCaseView, "statuses.json", %{statuses: statuses})
  end

end
