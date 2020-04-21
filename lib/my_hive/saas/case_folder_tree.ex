defmodule MyHive.Saas.CaseFolderTree do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Saas.Account
  alias MyHive.JsonLoader

  schema "saas_case_folder_trees" do
    field :name, :string
    field :json_tree, :map
    field :file_name, :string, virtual: true
    belongs_to :saas_account, Account, foreign_key: :saas_account_id
    timestamps()
  end

  @doc false
  def changeset(case_folder_tree, attrs) do
    case_folder_tree
    |> cast(attrs, [:json_tree, :name, :file_name])
    |> validate_required([:name, :file_name])
    |> process_json_file
  end

  def process_json_file(changeset) do
    file_name = get_change(changeset, :file_name)
    if file_name do
      content = JsonLoader.json_content(file_name)
      put_change(changeset, :json_tree, content)
    else
      changeset
    end
  end
end
