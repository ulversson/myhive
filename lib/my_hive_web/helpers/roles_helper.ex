

defmodule MyHiveWeb.Helpers.RolesHelper do
  alias MyHive.Accounts.User

  def roles_for_select(%User{roles: ["super_admin"]} = _) do
    User.valid_roles
  end

  def roles_for_select(%User{roles: ["expert"]} = _) do
    roles_without_super_admin()
  end

  def roles_for_select(%User{roles: ["admin"]} = _) do
    roles_without_super_admin()
  end

  def roles_for_select(nil) do
    roles_without_super_admin()
  end

  defp roles_without_super_admin do
    Keyword.delete(User.valid_roles, :"Super Admin")
  end

end
