alias MyHive.Oauth2


microsoft_provider = %{
  name: "Microsoft",
  enabled: true,
  icon: "fab fa-microsoft"
}

Oauth2.add_provider(microsoft_provider)
