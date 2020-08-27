defmodule  MyHive.FileManager.OnlyOfficeJwt do
  alias MyHive.FileManager.FileAsset
  import MyHiveWeb.Router.Helpers
  import MyHive.FileManager.OnlyOfficeCommonJwt

  def encode(asset) do
      payload = %{document:
      %{
        fileType: FileAsset.extension(asset),
        key: FileAsset.revision(),
        title: asset.name,
        url: download_url(asset),
      },
      documentType: FileAsset.doc_type(asset),
      editorConfig: %{
        callbackUrl:  callback_url(asset),
        customization: %{
          forcesave: true,
          autosave: false
         }#
      }
    }
    {:ok, json} = Poison.encode(payload)
    {str, 0} = System.cmd("bundle", ["exec" ,"ruby", path_to_rubyfile(), json])
    str |> String.trim
  end


  defp callback_url(asset) do
    document_provider_path(MyHiveWeb.Endpoint, :only_office_callback, asset.id)
  end

  def download_url(asset) do
    file_asset_url(MyHiveWeb.Endpoint, :show, asset.id) |> String.replace("443", "")
  end


end
