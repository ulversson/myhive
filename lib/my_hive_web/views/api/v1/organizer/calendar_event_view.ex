defmodule MyHiveWeb.Api.V1.CalendarEventView do
  alias MyHive.Organizer.CalendarEvent
  def render("calendar_event.json",%{event: event}) do
    event_json(event)
  end

  def render("events.json", %{events: events}) do
    %{
      data: Enum.map(events, fn event ->
        if (event.recurrence == "" || event.recurrence == nil) do
          event
        else
          CalendarEvent.from_parent(event)
        end
      end) |> List.flatten()
    }
  end

  defp event_json(event) do
    %{
      id: event.id,
      name: event.name,
      description: event.description,
      start_date: event.start_date,
      end_date: event.end_date,
      calendar_id: event.calendar_id,
      color: event.color,
      all_day: event.all_day,
      id: event.id,
      owner_id: event.owner_id
    }
  end
end
