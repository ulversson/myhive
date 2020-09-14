defmodule MyHive.Organizer do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Organizer.{
    Calendar, CalendarEvent
  }

  def create_calendar_for_user(user, changeset) do
    %Calendar{}
      |> Calendar.changeset(Map.merge(
        %{"owner_id" => user.id},
        changeset
      )) |> Repo.insert()
  end

  def create_event(user, changeset) do
    calendar_id = calendar_for_user(user).id
    %CalendarEvent{}
    |> CalendarEvent.changeset(Map.merge(
      %{
        "owner_id" => user.id,
        "calendar_id" => calendar_id
      },
      changeset
    )) |> Repo.insert()
  end

  def calendar_for_user(user) do
    query = from c in Calendar,
      where: c.owner_id == ^user.id,
      select: c
    Repo.one(query)
  end

  def preload(calendar) do
    Repo.preload(calendar, [:owner, :calendar_events])
  end

  def get_calendar_event(calendar_event_id) do
    Repo.get_by(CalendarEvent, id: calendar_event_id)
  end

  def remove_event(calendar_event) do
    Repo.delete(calendar_event)
  end

  def update_calendar_event(%CalendarEvent{} = event, params) do
    event
      |> CalendarEvent.changeset(params)
      |> Repo.update()
  end

  def remove_calendar_for(user) do
    query = from c in Calendar,
      where: c.owner_id == ^user.id,
      select: c
    Repo.delete_all(query)
  end
end
