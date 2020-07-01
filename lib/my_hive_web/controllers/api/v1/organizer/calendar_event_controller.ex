defmodule MyHiveWeb.Api.V1.CalendarEventController do
  use MyHiveWeb, :controller
  alias MyHive.Organizer
  def create(conn, %{"event_params" => event_params}) do
    user = conn.private.guardian_default_resource
    case Organizer.create_event(user, event_params) do
      {:ok, calendar_event} ->
        conn  |> render("calendar_event.json", %{
          event: calendar_event
        })
      {:error, changeset} ->
        conn |> MyHiveWeb.FallbackController.call({:error, changeset})
    end
  end
end
