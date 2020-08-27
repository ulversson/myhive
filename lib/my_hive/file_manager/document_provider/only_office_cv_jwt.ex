defmodule  MyHive.FileManager.OnlyOfficeCvJwt do
  alias MyHive.FileManager.FileAsset
  import MyHiveWeb.Router.Helpers
  import MyHive.FileManager.OnlyOfficeCommonJwt

  def encode(cv) do
      payload = %{document:
      %{
        fileType: FileAsset.extension(cv),
        key: FileAsset.revision(),
        title: cv.name,
        url: download_url(cv),
      },
      documentType: "text",
      "type": "desktop",
      "width": 800,
      "height": 500,
      editorConfig: %{
        callbackUrl:  callback_url(cv),
        customization: %{
          forcesave: true,
          autosave: false
         }
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

  defp callback_url(cv) do
    document_provider_url(MyHiveWeb.Endpoint, :only_office_cv_callback, cv.user_id)
  end

  defp download_url(cv) do
    document_provider_url(MyHiveWeb.Endpoint, :user_cv, cv.user_id)
  end

end
