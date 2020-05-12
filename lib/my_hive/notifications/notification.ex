defmodule MyHive.Notifications.Notification do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User

  @derive {
    Jason.Encoder,
    only: [:body, :icon, :topic, :viewed, :recipient_id, :sender_id]
  }
  schema "notifications" do
    field :body, :string
    field :icon, :string
    field :topic, :string
    field :viewed, :boolean, default: false
    belongs_to :recipient, User
    belongs_to :sender, User
    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:recipient_id, :topic, :body, :icon, :sender_id, :viewed])
    |> validate_required([:recipient_id, :topic, :body, :icon, :sender_id, :viewed])
  end
end
