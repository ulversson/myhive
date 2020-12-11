defmodule MyHive.FileManager.FileLinkResolver do
  alias MyHive.FileManager.{
    FileTypeResolver, DocumentProvider
  }
  alias MyHive.Annotations.TokenGenerator
  alias MyHive.Accounts
  import MyHiveWeb.Router.Helpers

  def call(nil, _user_id) do
    ""
  end

  def call(asset, user_id) do
    type = asset.name |> filetype()
    case type do
      value when value in ["video", "image", "audio", "other", "text"]
        -> asset_link(asset)
      value when value in ["pdf", "email"]
        -> pdf_link(asset, user_id)
      value when value in ["document", "excel"]
        -> document_provided_link(asset, user_id)
    end
  end

  defp document_provided_link(asset, user_id) do
    user_id
      |> Accounts.get_user!
      |> Accounts.document_provider
      |> DocumentProvider.provided_url(asset_link(asset), asset.id)
  end

  defp filetype(name) do
    FileTypeResolver.call(name)
  end

  defp asset_link(asset) do
    file_asset_url(MyHiveWeb.Endpoint, :show, asset.id)
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
