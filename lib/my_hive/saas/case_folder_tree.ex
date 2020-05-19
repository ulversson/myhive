defmodule MyHive.Saas.CaseFolderTree do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Saas.Account
  alias MyHive.JsonLoader

  schema "saas_case_folder_trees" do
    field :name, :string
    field :json_tree, :map
    field :file_name, :string, virtual: true
    field :uploaded_file, :any, virtual: true
    field :default, :boolean, default: false
    belongs_to :saas_account, Account, foreign_key: :saas_account_id
    timestamps()
  end

  @doc false
  def changeset(case_folder_tree, attrs) do
    case_folder_tree
    |> cast(attrs, [:json_tree, :name, :saas_account_id,
                      :file_name, :uploaded_file, :default])
    |> validate_required([:name, :uploaded_file])
    |> process_json_file()
    |> read_json_from_upload()
  end

  def as_json(tree) do
    {:ok, res} = tree.json_tree |> Jason.encode
    res
  end

  defp process_json_file(changeset) do
    file_name = get_change(changeset, :file_name)
    if file_name do
      content = JsonLoader.json_content(file_name)
      put_change(changeset, :json_tree, content)
    else
      changeset
    end
  end

  defp read_json_from_upload(changeset) do
    uploaded_file = get_change(changeset, :uploaded_file)
    if uploaded_file do
      {:ok, content} = JsonLoader.from_other_path(uploaded_file.path)
      put_change(changeset, :json_tree, content)
    else
      changeset
    end
  end
end
