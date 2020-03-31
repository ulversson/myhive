defmodule MyHive.Accounts.Auth do
  alias MyHive.Accounts.{Encryption, User}

  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  def generate_one_time_passcode()  do 
    token = :crypto.strong_rand_bytes(20) |> Base.encode32()
    one_time_pass = :pot.hotp(token, _number_of_trials = 1)
  end  
  
  defp authenticate(user, password) do
   if user do
       authenticated_user = case Encryption.validate_password(user, password) do
       {:ok, validated_user} -> validated_user.email == user.email
       {:error, _} -> false
       end
    else
      nil
    end
  end

  def signed_in?(conn) do
    conn.assigns[:current_user]
  end
end