defmodule MyHive.Encryption.FileAssetEncryptor do

  alias MyHive.FileManager.FileServer

  def call(asset, password_path) do
    file_path = FileServer.call(asset)
    Rambo.run("openssl", [
      "enc", "-aes-256-cbc", "-a", "-salt", "-in",
      file_path, "-out", (file_path<> ".enc"),
      "-pass", "file:#{password_path}"
    ])
    File.rm_rf(file_path)
  end


end
