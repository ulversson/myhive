defmodule MyHive.Organizer.CalendarEvent do
  use Ecto.Schema
  import Ecto.Changeset
  import MyHive.Avatarly.Generator
  alias MyHive.Accounts.User
  alias MyHive.Organizer.{
    Calendar,
    CalendarEvent
  }
  alias MyHive.Organizer.Services.DateRecurrenceCalculator

  @derive {
    Jason.Encoder,
    only: [:all_day, :description, :end_date, :name,
      :start_date, :color, :until_date]
  }
  schema "calendar_events" do
    field :all_day, :boolean, default: false
    field :description, :string
    field :end_date, :naive_datetime
    field :name, :string
    field :recurrence, :string
    field :start_date, :naive_datetime
    field :color, :string
    field :until_date, :naive_datetime
    belongs_to :owner, User, foreign_key: :owner_id
    belongs_to :calendar, Calendar
    timestamps()
  end

  @doc false
  def changeset(calendar_event, attrs) do
    calendar_event
    |> cast(attrs, [:name, :description, :color, :calendar_id, :owner_id, :start_date, :end_date,
      :all_day, :recurrence, :until_date])
    |> validate_required([:name, :description, :start_date, :end_date, :all_day])
    |> validate_end_date_after_start()
    |> set_event_color()
  end

  def validate_end_date_after_start(changeset) do
    starts_on = get_field(changeset, :start_date)
    ends_on = get_field(changeset, :end_date)

    if starts_on && ends_on && Date.compare(starts_on, ends_on) == :gt do
      add_error(changeset, :start_date, "cannot be later than end date")
    else
      changeset
    end
  end

  def set_event_color(changeset) do
    put_change(changeset, :color, random_color())
  end

  def occurences(calendar_event) do
    if calendar_event.until_date != nil do
      DateRecurrenceCalculator.call(
        calendar_event.start_date,
        calendar_event.until_date,
        calendar_event.recurrence
      )
    else
      DateRecurrenceCalculator.call(
        calendar_event.start_date,
        calendar_event.recurrence,
        40
      )
    end
  end

  def duration(calendar_event) do
    Timex.diff(calendar_event.end_date, calendar_event.start_date, :seconds)
  end

  def end_date_by_shifed_secs(start_date, calendar_event) do
    duration = duration(calendar_event)
    Timex.shift(start_date, seconds: duration)
  end

  def from_parent(calendar_event) do
    occurences(calendar_event)
      |> Enum.map(fn start_date ->
        %CalendarEvent{
          start_date: start_date,
          end_date: end_date_by_shifed_secs(start_date, calendar_event),
          name: calendar_event.name,
          description: calendar_event.description,
          color: calendar_event.color,
          all_day: calendar_event.all_day
        }
    end)
  end
end
