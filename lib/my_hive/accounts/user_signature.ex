defmodule MyHive.Accounts.UserSignature do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User

  schema "accounts_user_signatures" do
    field :image_content, :string
    field :content_type, :string
    belongs_to :user, User
    timestamps()
  end


  def signature64(sign) when is_map(sign) do
    "data:#{sign.content_type};base64,#{sign.image_content}"
  end

  def signature64(sign)  when is_nil(sign) do
    ""
  end

  @doc false
  def changeset(user_signature, attrs) do
    user_signature
    |> cast(attrs, [:user_id, :image_content, :content_type])
    |> validate_required([:user_id, :image_content, :content_type])
  end
end
