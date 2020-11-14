defmodule MyHive.Encryption.FilePasswordEncryptor do


  def call(password_path) do
    Rambo.run("openssl", [
      "smime", "-encrypt", "-binary" ,"-in",
       password_path, "-out", "#{password_path}.enc", "-aes256",
      pem_path()
    ])
    File.rm_rf(password_path)
    password_path <> ".enc"
  end

  def pem_path() do
    pem_config = Application.get_env(:my_hive, MyHiveWeb.Endpoint)[:files_pem]

    Path.expand(pem_config)
  end

end
