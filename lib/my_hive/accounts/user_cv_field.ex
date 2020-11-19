defmodule MyHive.Accounts.UserCVField do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.{
    Accounts, CVFields
  }
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

  def add_new_field(name, field_type) do
    {:ok, cv_field} = CVFields.create_field(%{
      name: name,
      field_type: field_type,
      order: length(CVFields.all)+1
    })
    Enum.each(Accounts.list_users(), fn user ->
      CVFields.create_user_cv_field(user, cv_field)
    end)
  end
end
