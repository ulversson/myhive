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

  def index(conn,_params) do
    user = conn.private.guardian_default_resource
    with user <- conn.private.guardian_default_resource,
         calendar <- Organizer.calendar_for_user(user)  do
      calendar_data = Organizer.preload(calendar)
      conn |> render("events.json", %{
        events: calendar_data.calendar_events
      })
    end
  end
end
