defmodule MyHive.Encryption.FileAssetDecryptionProcessor do

  alias MyHive.Encryption.{
    FilePasswordDecryptor,
    FileAssetDecryptor
  }


  def call(asset) do
    with password_path <- FilePasswordDecryptor.call(asset.enc_password_path)
      do
        FileAssetDecryptor.call(asset, password_path)
      end
  end


end
