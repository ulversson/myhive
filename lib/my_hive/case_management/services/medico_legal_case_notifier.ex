defmodule MyHive.CaseManagement.MedicoLegalCaseNotifier do
  alias MyHive.Notifications.NotificationsResolver
  alias MyHive.Notifications
  def call(user, mlc) do
    if !mlc.notifications_disabled do
      if (user.settings.notifications) do
        notification  = Notifications.create_for_case(user, mlc)
        NotificationsResolver.call(user, notification, mlc)
      end
    end
  end

end
