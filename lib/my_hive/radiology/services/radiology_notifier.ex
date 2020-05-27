defmodule MyHive.Radiology.RadiologyNotifier do
  alias MyHive.{
    CaseManagement,
    Accounts,
    Notifications,
    Repo
  }
  alias MyHive.Notifications.DicomNotificationsResolver

  def call(file_map, action) do
    mlc = CaseManagement
      .get_medico_legal_case!(file_map["medico_legal_case_id"])
      |> Repo.preload(:patient)
    user = Accounts.get_user!(file_map["user_id"])
    if action == :success do
      notification = success_notification(mlc, user)
      DicomNotificationsResolver.call(user, notification, mlc)
    else
      notification = failed_notification(mlc, user)
      DicomNotificationsResolver.call(user, notification, mlc)
    end
  end

  def success_notification(mlc, user) do
    Notifications.create(user, %{
      sender_id: user.id,
      body: success_body(mlc),
      icon: "fas fa-x-ray",
      topic: "[myHive] PACS archive has been processed"
    })
  end

  def failed_notification(mlc, user) do
    Notifications.create(user, %{
      sender_id: user.id,
      body: failed_body(mlc),
      icon: "fas fa-x-ray",
      topic: "[myHive] PACS archive processing error"
  })
  end

  defp success_body(mlc) do
    "Your uploaded PACS archive in the matter of:
      <strong>#{mlc.patient.first_name} #{mlc.patient.last_name}</strong>
        has been successfully processed and is available for browsing."
  end

  defp failed_body(mlc) do
    "Your uploaded PACS archive in the matter of:
    <strong>#{mlc.patient.first_name} #{mlc.patient.last_name}</strong>
    could NOT be processed. Please contact system administrator"
  end

end
