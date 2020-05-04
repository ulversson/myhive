defmodule MyHive.FileManager.FileAsset do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.FileManager.{Folder, FileMetadata}
  alias MyHive.Stats.ViewCounter
  import Ecto.Query, warn: false

  schema "file_assets" do
    field :caption, :string
    field :filetype, :string
    field :name, :string
    field :size, :integer
    field :uid, :string
    field :path, :string
    embeds_one :metadata, FileMetadata
    belongs_to :folder, Folder
    has_many :view_counters, ViewCounter, foreign_key: :countable_id, where: [countable_type: "FileAsset"]
    timestamps()
  end

  def with_view_counts(query) do
    from q in query, preload: [:view_counters]
  end
  @doc false
  def changeset(file_asset, attrs) do
    file_asset
    |> cast(attrs, [:folder_id, :name, :path, :filetype, :caption, :size, :uid])
    |> validate_required([:folder_id, :name, :path, :filetype, :size, :uid])
  end
end
