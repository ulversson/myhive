defmodule MyHive.Encryption.RSA do

  def generate do
    port = Port.open({:spawn, "openssl genrsa 2048"}, [:binary])
    priv_key_string
      =
      receive do
        {^port, {:data, data}} ->
          data
      end
    Port.close(port)
    [pem_entry] = :public_key.pem_decode(priv_key_string)
    pub_key = :public_key.pem_entry_decode(pem_entry) |> public_key
    pub_key_string = :public_key.pem_encode([:public_key.pem_entry_encode(:'RSAPublicKey', pub_key)])
    {priv_key_string, pub_key_string}
  end

  defp public_key({:RSAPrivateKey, _, modulus, public_exponent, _, _, _,_, _, _, _}) do
    { :RSAPublicKey, modulus, public_exponent }
  end
end
