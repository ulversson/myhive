defmodule MyHive.Organizer.Calendar do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.Organizer.CalendarEvent

  schema "organizer_calendars" do
    field :name, :string
    belongs_to :owner, User, foreign_key: :owner_id
    has_many :calendar_events, CalendarEvent
    timestamps()
  end

  @doc false
  def changeset(calendar, attrs) do
    calendar
    |> cast(attrs, [:name, :owner_id])
    |> validate_required([:name, :owner_id], message: "cannot be blank")
  end

end
