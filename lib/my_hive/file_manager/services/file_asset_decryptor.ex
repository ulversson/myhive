defmodule MyHive.FileManager.FileAssetDecryptor do

  alias MyHive.FileManager.{
    FileServer,
    FileAssetAllocator
  }
  alias MyHive.FileManager
  alias MyHive.Encryption.{
    FileAssetDecryptionProcessor,
    FileAssetEncryptionProcessor
  }

  def call(file_asset_id, password) do
    case FileManager.get_file_asset!(file_asset_id) do
      file_asset ->
        FileAssetDecryptionProcessor.call(file_asset)
        case file_asset.filetype do
          "application/pdf" ->
            case run_decryption(file_asset, file_asset.filetype, password) do
              2 -> nil
              0 ->
                FileAssetEncryptionProcessor.call(file_asset)
                FileManager.update_file_asset(file_asset, %{encrypted: false})
            end
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document" ->
              case run_decryption(file_asset, file_asset.filetype, password) do
                1 -> nil
                0 ->
                  data = FileAssetAllocator.call(decrypted_docx_file_name(file_asset), file_asset.name)
                  FileAssetEncryptionProcessor.call(file_asset)
                  FileManager.update_file_asset(file_asset, Map.merge(data, %{encrypted: false}))
              end
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

  defp run_decryption(file_asset, content_type, password) when content_type == "application/vnd.openxmlformats-officedocument.wordprocessingml.document" do
    {_str, code} = System.cmd("msoffcrypto-tool",[
      FileServer.call(file_asset),
      decrypted_docx_file_name(file_asset),
      "-p",
      password,
    ])
    code
  end

  defp run_decryption(_file_asset, content_type, _password) when content_type != "application/pdf" do
  end

  defp decrypted_docx_file_name(file_asset) do
    path = file_asset |> FileServer.call()
    ext = Path.extname(path)
    String.replace(path, ext, "-decrypted#{ext}")
  end
end
