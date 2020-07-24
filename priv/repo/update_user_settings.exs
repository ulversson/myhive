alias MyHive.{Repo, Accounts}

Enum.each(Accounts.list_users(), fn user ->
  user
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_embed(:settings,
      %MyHive.Accounts.Settings{
        document_provider_id: 1,
        default_color: "rgba(33, 150, 243, 0.75)",
        default_tab: "current",
        default_file_sort_column: "name",
        default_file_sort_order: "asc",
        notifications: true,
        new_items: false,
        in_app_notifications: true,
        text_messages_notifications: true,
        email_notifications: true
      })
    |> Repo.update
end)
