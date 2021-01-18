
alias MyHive.Saas.ApplicationModule
alias MyHive.{Saas, Repo}

Enum.each(Saas.app_modules(), fn modu ->
  icon = case modu.name do
    "Chat and Video calls" -> "fal fa-comments"
    "Time sheet" -> "fal fa-user-clock"
    "Calendar" -> "fal fa-calendar-day"
    "Blog and newsfeed" -> "fal fa-bullhorn"
    "Radiology" -> "fal fa-users"
  end
  ApplicationModule.changeset(modu, %{
    icon: icon
  }) |> Repo.update()
end)
