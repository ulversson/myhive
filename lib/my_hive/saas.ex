defmodule MyHive.Saas do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Saas.{
    Account,
    CaseFolderTree,
    Logo
  }

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def create_case_folder_tree(attrs \\ %{}) do
    %CaseFolderTree{}
    |> CaseFolderTree.changeset(attrs)
    |> Repo.insert()
  end

  def update_case_folder_tree(tree, attrs \\ %{}) do
    tree
    |> Ecto.Changeset.change(attrs)
    |> Repo.update()
  end

  def get_account!(id), do: Repo.get!(Account, id)
  def add_to_account(user, account_id) do
    account = Repo.get_by!(Account, id: account_id) |> Repo.preload(:users)
    user = user |>  Repo.preload(:saas_accounts)
    changeset = Ecto.Changeset.change(user)
    |> Ecto.Changeset.put_assoc(:saas_accounts, [account])
    Repo.update!(changeset)
  end

  def first_folder_tree() do
    Repo.one(from x in CaseFolderTree, order_by: [asc: x.id], limit: 1)
  end
  def first_account() do
    Repo.one(from x in Account, order_by: [asc: x.id], limit: 1)
  end
  def get_tree!(id), do: Repo.get!(CaseFolderTree, id)

  def tree_by_account_id(account_id) do
    Repo.get_by(CaseFolderTree, saas_account_id: account_id)
  end

  def add_logo(account, changeset) do
    logo = %Logo{}
      |> Logo.changeset(changeset)
    account
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_change(:logo, logo)
      |> Repo.update()
  end

  def update_settings(account, changes) do
    account = Repo.preload(account, [:address])
    account |> Account.changeset(changes)
      |> Repo.update()
  end

  def deactivate_tree_except(account_id, except_tree_id) do
    query = from t in CaseFolderTree,
      where: t.saas_account_id == ^account_id
        and t.id != ^except_tree_id
    query
      |> Repo.update_all(set: [
        default: false
      ])
  end
  def activate_tree(tree_id) do
    tree_id
      |> get_tree!()
      |> Ecto.Changeset.change(%{default: true})
      |> Repo.update()
  end
end
