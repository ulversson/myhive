defmodule MyHive.FileManager.FileAsset do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.FileManager.Folder

  schema "file_assets" do
    field :caption, :string
    field :filetype, :string
    field :name, :string
    field :size, :integer
    field :uid, :string
    belongs_to :folder, Folder
    timestamps()
  end

  @doc false
  def changeset(file_asset, attrs) do
    file_asset
    |> cast(attrs, [:folder_id, :name, :filetype, :caption, :size, :uid])
    |> validate_required([:folder_id, :name, :filetype, :size, :uid])
  end
end
