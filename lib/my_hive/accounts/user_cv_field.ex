defmodule MyHive.Accounts.UserCVField do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.{
    User, CVField
  }

  schema "accounts_user_cv_fields" do
    belongs_to :cv_field, CVField
    belongs_to :user, User
    field :field_value, :string
    field :order, :integer
    timestamps()
  end

  @doc false
  def changeset(user_cv_field, attrs) do
    user_cv_field
    |> cast(attrs, [:order, :field_value])
    |> validate_required([:order])
  end
end
