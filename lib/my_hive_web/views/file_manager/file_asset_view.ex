defmodule MyHiveWeb.Api.V1.FileAssetView do
  use MyHiveWeb, :view
  alias MyHive.FileManager.Icons

  def render("show.json", %{asset: asset}) do
    %{
      id: asset.id,
      name: asset.name,
      filetype: asset.filetype,
      folder_id: asset.folder_id,
      path: asset.path,
      view_counts: render_many(asset.view_counters,
        MyHiveWeb.Api.V1.Stats.ViewCounterView, "show.json",
        as: :view_count),
      icon: Icons.get_from_filename(asset.name),
      size: asset.size,
      uid: asset.uid,
      caption: asset.caption,
      updated_at: asset.updated_at
    }
  end

end
