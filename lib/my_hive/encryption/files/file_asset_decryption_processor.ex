defmodule MyHive.Encryption.FileAssetDecryptionProcessor do

  alias MyHive.Encryption.{
    FilePasswordDecryptor,
    FileAssetDecryptor
  }
  alias MyHive.FileManager.FileServer

  def call(asset) do
    asset_path = FileServer.call(asset)
    asset_dir = Path.dirname(asset_path)
    enc_pass_path = Path.join([asset_dir, asset.enc_password_path])
    with password_path <- FilePasswordDecryptor.call(enc_pass_path)
      do
        FileAssetDecryptor.call(asset, password_path)
      end
  end


end
