defmodule MyHiveWeb.Api.V1.FileManager.RecycleBinView do
  use MyHiveWeb, :view
  alias MyHive.FileManager.{
    FileTypeResolver,
    FileLinkResolver,
    Icons
  }
  alias MyHiveWeb.Api.V1.FileMetadataView

  def render("bin.json", %{assets: assets, user_id: user_id}) do
    Enum.map(assets, fn asset -> asset_json(asset, user_id) end)
  end

  def asset_json(asset, user_id) do
    %{
      id: asset.id,
      name: asset.name,
      filetype: asset.filetype,
      folder_id: asset.folder_id,
      path: asset.path,
      original_folder: (if (is_nil(asset.folder)), do: "", else: asset.folder.name),
      metadata: render_one(asset.metadata,
        FileMetadataView, "show.json", as: :metadata),
      assettype: FileTypeResolver.call(asset.name),
      deleted_at: asset.deleted_at,
      link: FileLinkResolver.call(asset, user_id),
      icon: Icons.get_from_filename(asset.name),
      size: asset.size,
      encrypted: asset.encrypted,
      uid: asset.uid,
      caption: asset.caption,
      updated_at: asset.updated_at
    }
  end
end
