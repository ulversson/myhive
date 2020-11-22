defmodule MyHive.Accounts.CVBundle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cv_bundles" do
    field :downloaded, :boolean, default: false
    field :generated_by, :integer
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(cv_bundle, attrs) do
    cv_bundle
    |> cast(attrs, [:generated_by, :path, :downloaded])
    |> validate_required([:generated_by, :path, :downloaded])
  end
end
