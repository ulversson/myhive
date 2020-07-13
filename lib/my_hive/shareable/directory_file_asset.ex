defmodule MyHive.Shareable.DirectoryFileAsset do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Shareable.Directory
  alias MyHive.FileManager.FileAsset

  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "shareable_directories_file_assets" do
    belongs_to :file_asset, FileAsset
    belongs_to :directory, Directory
    timestamps()
  end

  @doc false
  def changeset(directory_file_asset, attrs) do
    directory_file_asset
    |> cast(attrs, [:directory_id, :file_asset_id])
    |> validate_required([:directory_id, :file_asset_id])
  end
end
