defmodule MyHive.Encryption.OverwritingFileAssetEncryptionProcessor do

  alias MyHive.FileManager.FileServer
  alias MyHive.FileManager
  alias MyHive.Encryption.{
    FilePasswordDecryptor,
    FileAssetEncryptor
  }

  def call(asset) do
    storage_file_path = FileServer.call(asset)
    enc_pass_path = Path.join(Path.dirname(storage_file_path), asset.enc_password_path)
    with password_path <- FilePasswordDecryptor.call(enc_pass_path),
      {:ok, _} <- FileAssetEncryptor.call(asset, password_path) do
        FileManager.update_file_asset(asset, %{
          enc_password_path: Path.basename(enc_pass_path),
          file_encrypted: true
        })
        File.rm(password_path)
      end
  end
end
