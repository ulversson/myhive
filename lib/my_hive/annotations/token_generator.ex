defmodule MyHive.Annotations.TokenGenerator do

  @client_authority "my-hive.uk"
  @client_id "e7816088-35e1-11ea-82e9-0bc904ff620a"
  alias MyHive.Token

  def call(user) do
    now = DateTime.to_unix Timex.now
    userid = "acct:#{user_name(user)}@#{@client_authority}"
    payload = %{
      "aud" => "annotate2.my-hive.uk",
      "iss" => @client_id,
      "sub" => userid,
      "nbf" => now,
      "exp" => now + 600
    }
    Token.generate_and_sign(payload)
  end

  def user_name(user) do
    name = user.first_name  <> "." <> user.last_name
    String.replace(name, "-", "") |> String.downcase
  end
end
