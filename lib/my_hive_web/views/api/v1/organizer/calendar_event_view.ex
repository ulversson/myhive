defmodule MyHiveWeb.Api.V1.CalendarEventView do

  def render("calendar_event.json",%{event: event}) do
    %{
      id: event.id,
      name: event.name,
      description: event.description,
      start_date: event.start_date,
      end_date: event.end_date,
      calendar_id: event.calendar_id,
      color: event.color,
      all_day: event.all_day,
      owner_id: event.owner_id
    }
  end
end
