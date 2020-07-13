defmodule MyHive.Shareable.DirectoryFolder do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Shareable.Directory
  alias MyHive.FileManager.Folder

  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "shareable_directories_folders" do
    belongs_to :directory, Directory
    belongs_to :folder, Folder
    timestamps()
  end

  @doc false
  def changeset(directory_folder, attrs) do
    directory_folder
    |> cast(attrs, [:directory_id, :folder_id])
    |> validate_required([:directory_id, :folder_id])
  end
end
