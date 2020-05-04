defmodule MyHiveWeb.Api.V1.FileMetadataView do
  use MyHiveWeb, :view
  def render("show.json", %{metadata: metadata}) do
    %{
      width: metadata.width,
      height: metadata.height
    }
  end
end
