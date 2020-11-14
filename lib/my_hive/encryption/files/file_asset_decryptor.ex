defmodule MyHive.Encryption.FileAssetDecryptor do

  alias MyHive.FileManager.FileServer

  def call(asset, password_path) do
    unenc_path = FileServer.call(asset)
    file_path = unenc_path <> ".enc"
    Rambo.run("openssl", [
      "enc", "-d", "-aes-256-cbc", "-a", "-in",
      file_path, "-out", unenc_path,
      "-pass", "file:#{password_path}"
    ])
    File.rm_rf(password_path)
  end

end
