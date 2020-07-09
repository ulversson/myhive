alias MyHive.{Repo, Accounts, Organizer}
Repo.transaction (fn ->
  Enum.each(Accounts.list_users, fn user ->
    name = "#{user.first_name} #{user.last_name}'s Calendar"
    Organizer.create_calendar_for_user(user, %{
      "name" => name
    })
  end)
end)
