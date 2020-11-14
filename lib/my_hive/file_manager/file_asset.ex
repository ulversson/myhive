defmodule MyHive.FileManager.FileAsset do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.FileManager.{
    FileMetadata,
    FileTypeResolver
  }
  alias MyHive.Stats.ViewCounter
  alias MyHive.Stats
  import Ecto.Query, warn: false
  alias MyHive.Encryption.EncryptedField

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "file_assets" do
    field :caption, EncryptedField
    field :filetype, EncryptedField
    field :name, EncryptedField
    field :size, :string
    field :uid, EncryptedField
    field :path, EncryptedField
    field :folder_id, Ecto.UUID
    field :encrypted, :boolean, default: false
    field :enc_password_path, EncryptedField
    field :file_encrypted, :boolean, default: false
    embeds_one :metadata, FileMetadata
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
    asset.name
      |> Path.extname()
      |> String.replace(".","")
      |> String.downcase
      |> to_string
  end

  def revision() do
    :crypto.strong_rand_bytes(20) |> Base.url_encode64 |> binary_part(0, 20)
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
    |> cast(attrs, [:folder_id, :name, :encrypted, :path, :filetype, :caption, :size, :uid, :enc_password_path, :file_encrypted])
    |> validate_required([:folder_id, :name, :path, :filetype, :size, :uid])
  end
end
