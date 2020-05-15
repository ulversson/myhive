defmodule MyHive.FileManager.FileNotifier do

  alias MyHive.{
    Repo,
    FileManager,
    CaseManagement,
    Notifications
  }
  alias MyHive.FileManager.Folder
  alias MyHive.Notifications.FileManagerNotificationsResolver
  def call(file_asset) do
    medico_legal_case = file_asset.folder_id
     |> FileManager.get_folder!()
     |> folder_to_be_notified()
     |> CaseManagement.get_case_by_folder_id()

     medico_legal_case
      |> get_users()
      |> filter_those_to_notify()
      |> notify_them(medico_legal_case, file_asset)
  end

  defp get_users(medico_legal_case) do
    medico_legal_case = MyHive.Repo.preload(medico_legal_case, :users)
    medico_legal_case.users
  end

  defp notify_them(users, medico_legal_case, file_asset) do
    medico_legal_case = Repo.preload(medico_legal_case, [:patient])
    Enum.each(users, fn user ->
      notification = Notifications.create(user, %{
        sender_id: medico_legal_case.user_id,
        icon: "fas fa-file-upload",
        topic: "[myHive] New file has been uploaded",
        body: notification_body(medico_legal_case, file_asset)
      })
      FileManagerNotificationsResolver.call(user, notification, medico_legal_case)
    end)
  end

  defp filter_those_to_notify(users) do
    Enum.filter(users, fn user -> user.settings.new_items end)
  end

  defp notification_body(medico_legal_case, file_asset) do
    patient_name = medico_legal_case.patient.first_name <> " " <> medico_legal_case.patient.last_name
    "New file has been uploaded in the matter of #{patient_name}. File name: #{file_asset.name}"
  end

  defp folder_to_be_notified(%Folder{} = folder) do
    case folder.parent_id do
      nil -> folder.id
      _ -> FileManager.root_for_folder(folder.id).id
    end
  end

  defp folder_to_be_notified(nil) do
  end
end
