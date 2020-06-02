defmodule MyHive.ContactBook.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Encryption.EncryptedField

  schema "addresses" do
    field :address, EncryptedField
    field :addressable_id, :integer
    field :addressable_type, :string
    field :email, EncryptedField
    field :name, EncryptedField
    field :phone_number, EncryptedField

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:address, :addressable_id, :addressable_type, :phone_number, :email, :name])
    |> validate_required([:address, :addressable_type])
  end
  #|> validate_required_inclusion([:title , :content])
  def validate_required_inclusion(changeset, fields) do
    if Enum.any?(fields, &present?(changeset, &1)) do
      changeset
    else
      # Add the error to the first field only since Ecto requires a field name for each error.
      add_error(changeset, hd(fields), "One of these fields must be present: #{inspect fields}")
    end
  end

  def present?(changeset, field) do
    value = get_field(changeset, field)
    value && value != ""
  end
end
