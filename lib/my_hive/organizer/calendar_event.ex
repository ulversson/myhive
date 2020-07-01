defmodule MyHive.Organizer.CalendarEvent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calendar_events" do
    field :all_day, :boolean, default: false
    field :description, :string
    field :end_date, :naive_datetime
    field :name, :string
    field :recurrence, :string
    field :start_date, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(calendar_event, attrs) do
    calendar_event
    |> cast(attrs, [:name, :description, :start_date, :end_date, :all_day, :recurrence])
    |> validate_required([:name, :description, :start_date, :end_date, :all_day, :recurrence])
  end
end
