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
    %CalendarEvent{}
    |> CalendarEvent.changeset(Map.merge(
      %{"owner_id" => user.id},
      changeset
    )) |> Repo.insert()
  end
end
