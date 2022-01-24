defmodule MyHive.Shareable.Directory do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Shareable.{
    DirectoryFolder,
    DirectoryFileAsset,
    Authorization
  }
  alias MyHive.{
    Repo, CaseManagement, Saas
  }
  alias MyHive.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "shareable_directories" do
    field :approved, :boolean, default: false
    field :viewed, :boolean, default: false
    field :emails, :string
    field :note, :string
    field :token, :string
    field :first_name, :string
    field :last_name, :string
    field :expires, :date
    field :files, :any, virtual: true
    belongs_to :sharer, User, foreign_key: :shared_by
    belongs_to :medico_legal_case, CaseManagement.MedicoLegalCase
    belongs_to :saas_account, Saas.Account
    has_many :directory_folders, DirectoryFolder
    has_many :folders, through: [:directory_folders, :folder]
    has_many :directory_file_assets, DirectoryFileAsset
    has_many :file_assets, through: [:directory_file_assets, :file_asset]
    has_many :authorizations, Authorization, foreign_key: :shareable_directory_id
    timestamps()
  end

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:shared_by, :token,
      :medico_legal_case_id, :saas_account_id, :expires, :first_name, :last_name, :approved, :files, :note, :emails])
    |> generate_token()
    |> validate_required([:shared_by, :first_name, :last_name, :token, :files, :emails])
    |> add_tomorrows_date()
  end

  defp generate_token(changeset) do
    put_change(changeset, :token, Ecto.UUID.generate)
  end

  def valid_for_email?(dir, email) do
    emails = String.split(dir.emails, ",")
    Enum.member?(emails, email)
  end

  def is_asset_shared_member?(dir, asset) do
    dir = dir |> Repo.preload(:file_assets)
    Enum.member?(dir.file_assets, asset)
  end

  defp add_tomorrows_date(changeset) do
    put_change(changeset, :expires, tomorrow())
  end

  defp tomorrow() do
    Timex.today |> Timex.shift(days: 3)
  end
end
