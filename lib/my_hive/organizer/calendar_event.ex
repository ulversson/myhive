defmodule MyHive.Organizer.CalendarEvent do
  use Ecto.Schema
  import Ecto.Changeset
  import MyHive.Avatarly.Generator
  alias MyHive.Accounts.User
  alias MyHive.Organizer.Calendar

  schema "calendar_events" do
    field :all_day, :boolean, default: false
    field :description, :string
    field :end_date, :naive_datetime
    field :name, :string
    field :recurrence, :string
    field :start_date, :naive_datetime
    field :color, :string
    belongs_to :owner, User, foreign_key: :owner_id
    belongs_to :calendar, Calendar
    timestamps()
  end

  @doc false
  def changeset(calendar_event, attrs) do
    calendar_event
    |> cast(attrs, [:name, :description, :color, :calendar_id, :owner_id, :start_date, :end_date, :all_day, :recurrence])
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
end
