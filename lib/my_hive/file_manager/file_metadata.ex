defmodule MyHive.FileManager.FileMetadata do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :width, :integer
    field :height, :integer
  end
end
