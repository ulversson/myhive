defmodule MyHiveWeb.Api.V1.FileAssetView do
  use MyHiveWeb, :view
  alias MyHive.FileManager
  alias MyHive.FileManager.Icons

  def render("show.json", %{asset: asset}) do
    %{
      id: asset.id,
      name: asset.name,
      filetype: asset.filetype,
      folder_id: asset.folder_id,
      path: asset.path,
      full_path: "",
      icon: Icons.get_from_filename(asset.name),
      size: asset.size,
      uid: asset.uid,
      caption: asset.caption,
      updated_at: asset.updated_at
    }
  end

end
