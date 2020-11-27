defmodule MyHive.Oauth2.Provider do
  use Ecto.Schema
  import Ecto.Changeset

  schema "oauth2_providers" do
    field :enabled, :boolean, default: false
    field :name, :string
    field :icon, :string
    timestamps()
  end

  @doc false
  def changeset(provider, attrs) do
    provider
    |> cast(attrs, [:name, :enabled, :icon])
    |> validate_required([:name, :enabled])
  end
end
