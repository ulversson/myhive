defmodule MyHive.FileManager.FileAsset do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.FileManager.{Folder, FileMetadata, FileTypeResolver}
  alias MyHive.Stats.ViewCounter
  alias MyHive.Stats
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

  def with_view_counts(query, user_id) do
    from q in query,
    preload: [:view_counters],
    left_join: vc in assoc(q, :view_counters)
    query |> Stats.for_user(user_id)
  end

  def extension(asset) do
    asset.name |> Path.extname() |> String.replace(".","") |> to_string
  end

  def revision() do
    "123456789"
    #:crypto.strong_rand_bytes(20) |> Base.url_encode64 |> binary_part(0, 20)
  end

  def doc_type(asset) do
    case FileTypeResolver.call(asset.name) do
      "document" -> "text"
      "excel" -> "spreadsheet"
      _ -> ""
    end
  end
  @doc false
  def changeset(file_asset, attrs) do
    file_asset
    |> cast(attrs, [:folder_id, :name, :path, :filetype, :caption, :size, :uid])
    |> validate_required([:folder_id, :name, :path, :filetype, :size, :uid])
  end
end
