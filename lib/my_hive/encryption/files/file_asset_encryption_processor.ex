defmodule MyHive.Encryption.FileAssetEncryptionProcessor do

  alias MyHive.FileManager.FileServer
  alias MyHive.FileManager
  alias MyHive.Encryption.{
    Base64Pass,
    FilePasswordEncryptor,
    FileAssetEncryptor
  }

  def call(asset) do
    storage_file_path = FileServer.call(asset)

    with password_path <- Base64Pass.write(2048, storage_file_path),
      {:ok, _} <- FileAssetEncryptor.call(asset, password_path),
      enc_pass_path = FilePasswordEncryptor.call(password_path)
      do
        original_updated = asset.updated_at
        FileManager.update_file_asset(asset, %{
          enc_password_path: Path.basename(enc_pass_path),
          file_encrypted: true
        })
        FileManager.update_file_asset_ts(asset, original_updated)
      end
  end

end
