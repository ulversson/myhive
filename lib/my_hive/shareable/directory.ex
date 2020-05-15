defmodule MyHive.Shareable.Directory do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Shareable.{
    DirectoryFolder,
    DirectoryFileAsset
  }
  alias MyHive.Accounts.{
    User
  }
  schema "shareable_directories" do
    field :approved, :boolean, default: false
    field :viewed, :boolean, default: false
    field :emails, :string
    field :note, :string
    field :token, :string
    field :files, {:array, :string}, virtual: true
    belongs_to :sharer, User, foreign_key: :shared_by
    has_many :directory_folders, DirectoryFolder
    has_many :folders, through: [:directory_folders, :folder]
    has_many :directory_file_assets, DirectoryFileAsset
    has_many :file_assets, through: [:directory_file_assets, :file_asset]
    timestamps()
  end

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:shared_by, :token, :approved, :files, :note, :emails])
    |> generate_token()
    |> validate_required([:shared_by, :token, :note, :files, :emails])
  end

  defp generate_token(changeset) do
    put_change(changeset, :token, Ecto.UUID.generate)
  end
end
