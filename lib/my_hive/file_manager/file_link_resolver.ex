defmodule MyHive.FileManager.FileLinkResolver do
  alias MyHive.FileManager.FileTypeResolver
  alias MyHive.Annotations.TokenGenerator
  import MyHiveWeb.Router.Helpers

  def call(asset, user_id) do
    type = asset.name |> filetype()
    case type do
      value when value in ["video", "image", "audio", "other", "text"]
        -> asset_link(asset)
      value when value in ["pdf", "email"]
        -> pdf_link(asset, user_id)
      value when value in ["document", "excel"]
        -> ""
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
