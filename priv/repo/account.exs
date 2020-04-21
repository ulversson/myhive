alias MyHive.Accounts.User
alias MyHive.Accounts
alias MyHive.Saas.Account
alias MyHive.Saas.AccountUser
alias MyHive.Saas
alias MyHive.Repo


account_map = %{
  name: System.get_env("DEFAULT_ACCOUNT"),
  max_users: 1000
}

changeset = Account.changeset(%Account{}, account_map)
account = Repo.insert!(changeset) |> Repo.preload(:users)

user = %User{
  first_name: "Super",
  last_name: "Admin",
  verified: true,
  email:  "admin@example2.net",
  password: "Password2me2",
  password_confirmation: "Password2me2",
  phone_number: "+(44)7932-876-596",
  roles: ["super_admin"]
}
user = Repo.insert!(user) |> Repo.preload(:saas_accounts)
changeset = Ecto.Changeset.change(user) |> Ecto.Changeset.put_assoc(:saas_accounts, [account])
Repo.update!(changeset)
Accounts.update_password(user, "Password2me2")
