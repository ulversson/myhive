alias MyHive.{Repo, Accounts}
alias MyHive.FileManager.DocumentProvider
alias MyHive.Accounts.Settings

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
      |> Ecto.Changeset.put_change(:settings,
        %MyHive.Accounts.Settings{
          document_provider_id: 1,
          default_color: "text-secondary"
        })
      |> Repo.update
  end)
end)
