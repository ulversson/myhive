defmodule MyHive.FileManager.FileAssetDecryptor do

  alias MyHive.FileManager.FileServer
  alias MyHive.FileManager

  def call(file_asset_id, password) do
    case FileManager.get_file_asset!(file_asset_id) do
      file_asset ->
        case run_decryption(file_asset, file_asset.filetype, password) do
          2 -> nil
          0 -> FileManager.update_file_asset(file_asset, %{encrypted: false})
        end
    end
  end

  defp run_decryption(file_asset, content_type, password) when content_type == "application/pdf" do
    {_str, code} = System.cmd("qpdf",[
      "--decrypt",
      "--replace-input",
      "--password=#{password}",
      FileServer.call(file_asset),
    ])
    code
  end

  defp run_decryption(_file_asset, content_type, _password) when content_type != "application/pdf" do
  end

end
