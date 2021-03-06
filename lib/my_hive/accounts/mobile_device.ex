defmodule MyHive.Accounts.MobileDevice do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User

  schema "account_mobile_devices" do
    field :os, :string
    field :token, :string
    field :device_type, :string
    field :udid, :string
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(mobile_device, attrs) do
    mobile_device
    |> cast(attrs, [:os, :token, :user_id, :device_type, :udid])
    |> validate_required([:os, :token, :user_id])
  end
end
