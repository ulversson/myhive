defmodule MyHive.Notifications.NotificationsCommon do

  def enabled_notifications_for_user(user) do
    notification_settings = Map.take(user.settings,
      [:in_app_notifications, :email_notifications, :text_messages_notifications])
    :maps.filter(fn _, v -> v == true end, notification_settings)
  end

  def notifications_to_notify(user, notify_map) do
    :maps.filter(fn k, _v ->
      enabled_notifications_for_user(user)[k] == true end, notify_map)
  end
end
