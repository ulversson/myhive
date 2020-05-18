defmodule MyHive.Notifications.Notification do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User

  @derive {
    Jason.Encoder,
    only: [:body, :icon, :topic,
      :id, :viewed, :inserted_at,
      :show_on_arrival, :recipient_id, :sender_id]
  }
  schema "notifications" do
    field :body, :string
    field :icon, :string
    field :topic, :string
    field :viewed, :boolean, default: false
    field :show_on_arrival, :boolean, default: false
    field :expires, :date
    belongs_to :recipient, User
    belongs_to :sender, User
    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:recipient_id, :topic, :body, :show_on_arrival, :icon, :sender_id, :viewed])
    |> validate_required([:recipient_id, :topic, :body, :icon, :sender_id, :viewed])
    |> add_tomorrows_date()
  end

  defp add_tomorrows_date(changeset) do
    put_change(changeset, :expires, tomorrow())
  end

  defp tomorrow() do
    Timex.today |> Timex.shift(days: 1)
  end
end
