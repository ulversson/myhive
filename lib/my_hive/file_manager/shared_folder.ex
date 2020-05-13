defmodule MyHive.FileManager.SharedFolder do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.FileManager.Folder
  alias MyHive.Accounts.User

  schema "file_manager_shared_folders" do
    belongs_to :folder, Folder
    belongs_to :shared_user, User, foreign_key: :shared_user_id
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(shared_folder, attrs) do
    shared_folder
    |> cast(attrs, [:folder_id, :user_id, :shared_user_id])
    |> validate_required([:folder_id, :user_id, :shared_user_id])
  end
end
