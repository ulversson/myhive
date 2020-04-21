defmodule MyHive.FileManager.Folder do
  use Ecto.Schema
  use Arbor.Tree
  import Ecto.Changeset
  alias MyHive.Accounts.User

  schema "folders" do
    field :folder_type, :string
    field :name, :string
    belongs_to :parent, __MODULE__
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, [:user_id, :parent_id, :name, :folder_type])
    |> validate_required([:user_id, :name, :folder_type])
  end
end
