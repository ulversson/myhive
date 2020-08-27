defmodule MyHiveWeb.Api.V1.FileAssetView do
  use MyHiveWeb, :view
  import Ecto.Query, warn: false
  alias MyHive.Stats
  alias MyHive.FileManager.{
    FileTypeResolver,
    FileLinkResolver,
    Icons
  }

  def render("show.json", %{asset: asset, user_id: user_id}) do
    %{
      id: asset.id,
      name: asset.name,
      filetype: asset.filetype,
      folder_id: asset.folder_id,
      path: asset.path,
      metadata: render_one(asset.metadata, MyHiveWeb.Api.V1.FileMetadataView,
      "show.json", as: :metadata),
      view_counts:  Stats.view_counts(user_id, asset.id),
      assettype: FileTypeResolver.call(asset.name),
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
