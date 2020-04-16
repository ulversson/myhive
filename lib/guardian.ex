
defmodule MyHive.Guardian do
  use Guardian, otp_app: :my_hive

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end
  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = MyHive.Accounts.get_user!(id)
    {:ok,  resource}
  end

end
