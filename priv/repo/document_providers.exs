alias MyHive.{Repo, Accounts}
alias MyHive.FileManager.DocumentProvider

providers = [
  %{
    name: "Only Office",
    code: "only_office",
    remote_url: "/only_office/[ID]"
  },
  %{
    name: "MS Office Viewer",
    code: "ms_office",
    remote_url: "https://view.officeapps.live.com/op/view.aspx?src=[item_url]"
  }
]
Repo.transaction (fn ->
  Enum.each(providers, fn prov ->
    %DocumentProvider{}
      |> Ecto.Changeset.change(prov)
      |> Repo.insert
  end)
  Enum.each(Accounts.list_users, fn user ->
    user
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_embed(:settings,
        %MyHive.Accounts.Settings{
          document_provider_id: 1,
          default_color: "rgba(33, 150, 243, 0.75)",
          default_tab: "current",
          notifications: true,
          new_items: false,
          in_app_notifications: true,
          text_messages_notifications: true,
          email_notifications: true
        })
      |> Repo.update
  end)
end)
