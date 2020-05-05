defmodule MyHive.FileManager.FileMetadata do
  use Ecto.Schema

  embedded_schema do
    field :width, :integer
    field :height, :integer
  end
end
