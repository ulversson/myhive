defmodule MyHive.EmailTemplates.UserEmailSignature do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User

  schema "user_signatures" do
    field :active, :boolean, default: false
    field :content, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(user_email_signature, attrs) do
    user_email_signature
    |> cast(attrs, [:user_id, :content, :active])
    |> validate_required([:user_id, :content, :active])
  end
end
