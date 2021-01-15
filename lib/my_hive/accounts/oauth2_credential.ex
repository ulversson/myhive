defmodule MyHive.Accounts.OAuth2Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.Oauth2.Provider

  @derive {
    Jason.Encoder,
    only: [:email, :name, :provider, :token]
  }
  schema "oauth2_credentials" do
    field :email, :string
    field :expires_at, :naive_datetime
    field :name, :string
    field :refresh_token, :string
    field :token, :string
    belongs_to :user, User
    belongs_to :provider, Provider
    timestamps()
  end

  @doc false
  def changeset(o_auth_credential, attrs) do
    o_auth_credential
    |> cast(attrs, [:provider_id, :email, :name, :token, :refresh_token, :expires_at, :user_id])
    |> validate_required([:provider_id, :email, :name, :token, :refresh_token, :expires_at, :user_id])
  end
end
