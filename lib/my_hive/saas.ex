defmodule MyHive.Saas do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Saas.{
    Account,
    CaseFolderTree,
    Logo,
    ApplicationModule,
    AccountApplicationModule
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
    account = Repo.get_by!(Account, id: account_id)
      |> Repo.preload(:users)
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

  def remove_tree(tree_id) do
    tree_id |> get_tree!() |> Repo.delete()
  end

  def get_active_tree(account_id) do
    query = from t in CaseFolderTree,
    where: t.saas_account_id == ^account_id
    and t.default == true
    Repo.one(query)
  end

  def app_modules() do
    Repo.all(from x in ApplicationModule, order_by: [asc: x.name])
  end

  def activate_module(account_id, module_id) do
    %AccountApplicationModule{}
      |> AccountApplicationModule.changeset(%{
        saas_account_id: account_id,
        application_module_id: module_id,
        activated_at: Timex.now("Europe/London")
      })
    |> Repo.insert()
  end

  def app_modules_ids_for_account(account_id) do
    query = from aam in AccountApplicationModule,
      where: aam.saas_account_id == ^account_id
        and is_nil(aam.deactivated_at),
      select: aam.application_module_id
    Repo.all(query)
  end

  def app_modules_by_ids(ids) do
    query = from am in ApplicationModule,
      where: am.id in ^ids
    Repo.all(query)
  end

  def get_account_application_module(account_id, module_id) do
    query = from aam in AccountApplicationModule,
    where: aam.saas_account_id == ^account_id
      and aam.application_module_id == ^module_id
      and is_nil(aam.deactivated_at)
    Repo.one(query)
  end

  def deactivate_module(account_id, module_id) do
    account_id
      |> get_account_application_module(module_id)
      |> AccountApplicationModule.changeset(%{
        deactivated_at: Timex.now("Europe/London")
      })
    |> Repo.update()
  end

  def get_active_modules_for(account_id) do
    query = from aam in AccountApplicationModule,
    where: aam.saas_account_id == ^account_id
      and is_nil(aam.deactivated_at)
    items = Repo.all(query)
    Repo.preload(items, [:application_module])
  end
end
