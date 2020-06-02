alias MyHive.Saas.CaseFolderTree
alias MyHive.Saas
alias MyHive.Repo

account = Saas.first_account()

case_tree_map = %{
  name: "Genesis",
  file_name: "folders.json",
  saas_account: account
}

changeset = CaseFolderTree.changeset(%CaseFolderTree{}, case_tree_map)

account = Repo.insert!(changeset)

