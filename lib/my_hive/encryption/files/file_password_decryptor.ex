defmodule MyHive.Encryption.FilePasswordDecryptor do


  def call(enc_password_path) do
    Rambo.run("openssl", [
      "smime", "-decrypt", "-binary" ,"-in",
      enc_password_path, "-out", String.replace(enc_password_path, ".enc", ""),
      "-aes256", "-recip", pem_path(), "-inkey", key_path()
    ])
    String.replace(enc_password_path, ".enc","")
  end


  def pem_path() do
    pem_config = Application.get_env(:my_hive, MyHiveWeb.Endpoint)[:files_pem]

    Path.expand(pem_config)
  end


  def key_path() do
    key = Application.get_env(:my_hive, MyHiveWeb.Endpoint)[:files_key]

    Path.expand(key)
  end
end
