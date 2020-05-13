defmodule MyHive.FileManager.Folder do
  use Ecto.Schema
  use Arbor.Tree
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.FileManager.
    {FileAsset, SharedFolder}
  alias MyHive.Stats.ViewCounter

  schema "folders" do
    field :folder_type, :string
    field :name, :string
    field :description, :string
    belongs_to :parent, __MODULE__
    belongs_to :user, User
    has_many :file_assets, FileAsset
    has_many :view_counters, ViewCounter, foreign_key: :countable_id, where: [countable_type: "Folder"]
    has_many :asset_view_counts, through: [:file_assets, :view_counters]
    has_many :shared_folders, SharedFolder,  on_delete: :delete_all
    has_many :shared_with_users, through: [:shared_folders, :shared_user]

    timestamps()
  end

  def with_view_counts(query) do
    from q in query, preload: [:view_counters]
  end

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, [:user_id, :parent_id, :description, :name, :folder_type])
    |> validate_required([:user_id, :name, :folder_type])
  end
end
