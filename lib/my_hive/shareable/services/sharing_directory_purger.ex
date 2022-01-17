defmodule MyHiveWeb.Plugs.SharingDirectoryPurger do
  alias MyHive.{
    Repo, Shareable, Notifications
  }
  alias MyHiveWeb.Plugs.ShareableDirectoryNotifier

  def call() do
    Shareable.get_old_shared_directories()
    |> Repo.all()
    |> Enum.each(fn directory ->
      unless directory.approved do
        directory = Repo.preload(directory,[:sharer])
        notification = Notifications.create(directory.sharer, %{
          topic: "[my-hive] Shared files had been deleted without being viewed",
          body: "User #{name(directory)} had never authorized their identity and the shared files had been deleted from the system",
          icon: "fas fa-user-times",
          sender_id: directory.sharer.id,
          show_on_arrival: true
        })
        ShareableDirectoryNotifier.call(notification, directory, "never accessed")
      end
      Repo.delete(directory)
    end)
  end

  defp name(dir) do
    "<strong>" <> dir.first_name <> " " <> dir.last_name <> "</strong>"
  end

end
