defmodule MyHive.FileManager.FileMetadataReader do
  import Mogrify
  alias MyHive.FileManager.FileServer

  def call(asset, "image") do
    require IEx; IEx.pry
    image = asset |> FileServer.call |> open() |> verbose
    asset
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_change(:metadata,
        %{width: image.width, height: image.height})
      |> MyHive.Repo.update
  end

  def call(_asset, _) do
  end
end
