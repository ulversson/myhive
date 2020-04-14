defmodule MyHive.Accounts.Token do
  
  alias MyHive.Accounts.User
  
  @account_verification_salt "WBveD2SWxEsITVK7OlGXs5/78G/8nuFGjdAP5HxKfhe2/eJvdjvc7tEBeX23q4/a"

  def generate_new_account_token(%User{id: user_id}) do
    Phoenix.Token.sign(MyHiveWeb.Endpoint, @account_verification_salt, user_id)
  end

  def verify_new_account_token(token) do
    max_age = 86_400 # tokens that are older than a day should be invalid
    Phoenix.Token.verify(MyHiveWeb.Endpoint, @account_verification_salt, token, max_age: max_age)
  end
end