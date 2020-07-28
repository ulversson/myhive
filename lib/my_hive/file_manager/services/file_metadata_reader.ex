defmodule MyHive.FileManager.FileMetadataReader do
  import Mogrify
  alias MyHive.FileManager.FileServer

  def call(asset, "image") do
    path = asset |> FileServer.call
    if File.exists?(path) do
      image = path |> open() |> verbose
      update_image(asset, image.width, image.height)
    else
      update_image(asset, 0, 0)
    end
  end

  def call(_asset, _) do
  end

  defp update_image(asset, width, height) do
    asset
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_change(:metadata,
        %{width: width, height: height})
      |> MyHive.Repo.update
  end
end
