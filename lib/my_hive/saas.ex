defmodule MyHive.Saas do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Saas.{Account, CaseFolderTree}

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def create_case_folder_tree(attrs \\ %{}) do
    %CaseFolderTree{}
    |> CaseFolderTree.changeset(attrs)
    |> Repo.insert
  end

  def get_account!(id), do: Repo.get!(Account, id)


  def add_to_account(user, account_id) do
    account = Repo.get_by!(Account, id: account_id) |> Repo.preload(:users)
    user = user |>  Repo.preload(:saas_accounts)
    changeset = Ecto.Changeset.change(user)
    |> Ecto.Changeset.put_assoc(:saas_accounts, [account])
    Repo.update!(changeset)
  end

  @spec first_folder_tree :: any
  def first_folder_tree() do
    Repo.one(from x in CaseFolderTree, order_by: [asc: x.id], limit: 1)
  end
  def first_account() do
    Repo.one(from x in Account, order_by: [asc: x.id], limit: 1)
  end
  def get_tree!(id), do: Repo.get!(CaseFolderTree, id)


end
