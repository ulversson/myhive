defmodule MyHive.Saas.Services.TreeHoover do
  alias MyHive.{
    Repo, Saas
  }
  alias MyHive.Saas.Services.TreeActivator
  def call(account_id, tree_id) do
    Repo.transaction(fn ->
      Saas.remove_tree(tree_id)
      tree = Saas.first_folder_tree()
      TreeActivator.call(account_id, tree.id)
    end)
  end
end
