defmodule MyHiveWeb.Api.V1.CalendarEventController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Accounts,
    Organizer
  }
  plug MyHiveWeb.Plugs.AuthorizationPlug, [:admin, :super_admin] when action in [:other]

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
    with user <- conn.private.guardian_default_resource,
         calendar <- Organizer.calendar_for_user(user)  do
      calendar_data = Organizer.preload(calendar)
      conn |> render("events.json", %{
        events: calendar_data.calendar_events,
        role: user.roles
      })
    end
  end

  def for_user(conn, %{"user_id" => user_id}) do
    with user <- Accounts.get_user!(user_id),
         calendar <- Organizer.calendar_for_user(user)  do
      calendar_data = Organizer.preload(calendar)
      conn |> render("events.json", %{
        events: calendar_data.calendar_events,
        role: user.roles
      })
    end
  end

  def destroy(conn, %{"id" => id}) do
    id
      |> Organizer.get_calendar_event()
      |> Organizer.remove_event()

    conn |> json(%{
      "status" => "ok",
      "message" => "Event has been removed"
    })
  end

  def update(conn, %{"id" => id, "event_params" => event_params}) do
    cal_event = Organizer.get_calendar_event(id)
    case Organizer.update_calendar_event(cal_event, event_params) do
      {:error, changeset} ->
        conn |> MyHiveWeb.FallbackController.call({:error, changeset})
      {:ok, _cal_event} ->
        conn |> json(%{"success" => true})
    end
  end
end
