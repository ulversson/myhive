defmodule MyHive.Shareable.Authorization do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Shareable.Directory

  @foreign_key_type :binary_id
  schema "shareable_authorizations" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :token, :string
    belongs_to :directory, Directory, foreign_key: :shareable_directory_id
    timestamps()
  end

  @doc false
  def changeset(authorization, attrs) do
    authorization
    |> cast(attrs, [:first_name, :last_name, :token, :shareable_directory_id, :email])
    |> validate_required([:first_name, :last_name, :token, :shareable_directory_id, :email])
  end
end
