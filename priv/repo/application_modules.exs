
alias MyHive.Saas.ApplicationModule
alias MyHive.Repo
modules = [
  %{
    name: "Chat and Video calls",
    short_name: "Chat",
    description: "Allows to create chat rooms and run video calls inside myHive",
    icon: "far fa-comments",
    monthly_price: 50
  },
  %{
    name: "Time sheet",
    short_name: "Time sheet",
    description: "Allows to track the time spent on the cases and download reports",
    icon: "fas fa-user-clock",
    monthly_price: 30
  },
  %{
    name: "Calendar",
    short_name: "Calendar",
    description: "Allows to create events and notify users about them.",
    icon: "fas fa-calendar-day",
    monthly_price: 30
  },
  %{
    name: "Blog and newsfeed",
    short_name: "Newsfeed",
    description: "Allows to post important information about business and keep your users upto date. ",
    icon: "fas fa-bullhorn",
    monthly_price: 25
  },
  %{
    name: "Radiology",
    short_name: "Radiology",
    description: "Shows uploaded PACS images in a radiology browser",
    icon: "fas fa-x-ray",
    monthly_price: 75
  }
]

Enum.each(modules, fn mod ->
  %ApplicationModule{}
  |> ApplicationModule.changeset(mod)
  |> Repo.insert()
end)
