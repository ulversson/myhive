
alias MyHive.Accounts
alias MyHive.Accounts.CvGenerator

Enum.each(Accounts.list_users(), fn user ->
  CvGenerator.call(user.id)
end)
