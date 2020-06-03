defmodule MyHive.Saas.Services.AppModulesRetriever do
  alias MyHive.Saas

  def call(account_id) do
    account_id
      |> Saas.app_modules_ids_for_account()
      |> Saas.app_modules_by_ids
  end
end
