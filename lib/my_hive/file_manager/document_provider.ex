defmodule MyHive.FileManager.DocumentProvider do
  use Ecto.Schema
  import Ecto.Changeset

  schema "file_manager_document_providers" do
    field :code, :string
    field :name, :string
    field :remote_url, :string

    timestamps()
  end

  def provided_url(provider, file_location, asset_id \\ nil) do
    if provider.remote_url =~ "[item_url]" do
      String.replace(provider.remote_url, "[item_url]", URI.encode(file_location))
    else
      String.replace(provider.remote_url, "[ID]", to_string(asset_id))
    end
  end
  @doc false
  def changeset(document_provider, attrs) do
    document_provider
    |> cast(attrs, [:name, :code, :remote_url])
    |> validate_required([:name, :code, :remote_url])
  end
end


