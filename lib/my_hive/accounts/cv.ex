defmodule MyHive.Accounts.CV do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User

  schema "accounts_cvs" do
    field :path, :string
    field :size, :integer
    field :name, :string
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(cv, attrs) do
    cv
    |> cast(attrs, [:path, :user_id, :size, :name])
    |> validate_required([:path, :user_id, :name, :size])
  end

  def template_path do
    Path.join(:code.priv_dir(:my_hive), "data/template.docx")
  end
end
