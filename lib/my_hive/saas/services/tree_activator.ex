defmodule MyHive.Saas.Services.TreeActivator do
  alias MyHive.{
    Repo, Saas
  }
  def call(account_id, tree_id) do
    Repo.transaction(fn ->
      Saas.activate_tree(tree_id)
      Saas.deactivate_tree_except(account_id, tree_id)
    end)
  end
end
