defmodule MyHiveWeb.Api.V1.FileManager.RecycleBinView do
  use MyHiveWeb, :view
  alias MyHive.FileManager
  alias MyHive.FileManager.{
    FileTypeResolver,
    FileLinkResolver,
    FolderTypeResolver,
    Icons
  }
  alias MyHiveWeb.Api.V1.FileMetadataView

  def render("bin.json", %{assets: assets, folders: folders, user_id: user_id}) do
    %{
      files: Enum.map(assets, fn asset -> asset_json(asset, user_id) end),
      folders: Enum.map(folders, fn folder -> folder_json(folder) end),
    }
  end

  def asset_json(asset, user_id) do
    %{
      id: asset.id,
      name: asset.name,
      filetype: asset.filetype,
      folder_id: asset.folder_id,
      path: asset.path,
      original_folder: (if (is_nil(asset.folder)), do: "Unknown", else: asset.folder.name),
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


  def folder_json(folder) do
    %{
      id: folder.id,
      name: folder.name,
      parent_id: folder.parent_id,
      description: folder.description,
      folder_type: folder.folder_type,
      original_folder: root_for(folder),
      trackable: folder.trackable,
      deleted_at: folder.deleted_at,
      updated: folder.updated_at,
      icon: FolderTypeResolver.icon(folder.folder_type),
    }
  end

  defp clean_folder_name(folder) do
    String.replace(folder.name, ".", " ")
  end

  defp root_for(folder) do
    if (is_nil(folder.parent_id)) do
      clean_folder_name(folder)
    else
      root = FileManager.root_for(folder.id)
      name_for_root(root)
    end
  end

  defp name_for_root(root)  when is_map(root) do
    root.name
  end

  defp name_for_root(root)  when is_nil(root) do
    "(deleted)"
  end
end
