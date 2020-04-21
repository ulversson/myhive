defmodule MyHiveWeb.UserLive.CommonUser do
  alias MyHive.Accounts

  def get_current_user(%{"current_user_id" => id}) do
    Accounts.get_user!(id) |> MyHive.Repo.preload(:saas_accounts)
  end

  def get_current_user(_) do
  end

end
