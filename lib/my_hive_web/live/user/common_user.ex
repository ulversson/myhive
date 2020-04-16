defmodule MyHiveWeb.UserLive.CommonUser do
  alias MyHive.Accounts

  def get_current_user(%{"user_id" => id}) do
    Accounts.get_user!(id)
  end

  def get_current_user(_) do
  end

end
