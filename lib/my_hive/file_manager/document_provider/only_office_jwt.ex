defmodule  MyHive.FileManager.OnlyOfficeJwt do
  alias MyHive.FileManager.FileAsset
  import MyHiveWeb.Router.Helpers

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

  def decode(token) do
    {str, 0} = System.cmd("bundle", ["exec" ,"ruby", path_to_rubyfile("jwt_to_json.rb"), token])
    {:ok, map} = str |>
      String.trim |> Poison.decode
    map
  end

  defp path_to_rubyfile(file \\ "json_to_jwt.rb") do
    if env() == :dev do
      Path.join([File.cwd!, "lib", "my_hive", "file_manager", "document_provider", file])
    else
      Path.join([File.cwd!, file])
    end
  end

  defp callback_url(asset) do
    document_provider_path(MyHiveWeb.Endpoint, :only_office_callback, asset.id)
  end

  def download_url(asset) do
    file_asset_url(MyHiveWeb.Endpoint, :show, asset.id) |> String.replace("443", "")
  end

  defp env do
    Application.get_env(:my_hive, :environment)
  end
end
