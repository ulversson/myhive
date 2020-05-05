defmodule MyHive.FileManager.FileLinkResolver do
  alias MyHive.FileManager.FileTypeResolver
  alias MyHive.Annotations.TokenGenerator
  import MyHiveWeb.Router.Helpers

  def call(asset, user_id) do
    type = asset.name |> filetype()
    case type do
      "video" -> asset_link(asset)
      "image" -> asset_link(asset)
      "audio" -> asset_link(asset)
      "pdf"   -> pdf_link(asset, user_id)
      "other" -> asset_link(asset)
      "text"  -> asset_link(asset)
      "email" -> pdf_link(asset, user_id)
      "document" -> ""
      "excel"  -> ""
    end
  end

  defp filetype(name) do
    FileTypeResolver.call(name)
  end

  defp asset_link(asset) do
    file_asset_path(MyHiveWeb.Endpoint, :show, asset.id)
  end

  defp annotations_token(user) do
    {:ok, jwt, _claims} = TokenGenerator.call(user)
    jwt
  end

  defp pdf_link(asset, user_id) do
    user = MyHive.Accounts.get_user!(user_id)
    "#{MyHiveWeb.Endpoint.url}/web/viewer.html?file=#{MyHiveWeb.Endpoint.url}/downloads/#{asset.id}&jwt=#{annotations_token(user)}"
  end

end
