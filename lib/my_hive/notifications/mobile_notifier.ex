defmodule MyHive.Notifications.MobileNotifier do
  alias MyHive.SmsNotifications.SmsMessage
  alias MyHive.Notifications.ApnsPostman
  alias MyHive.Accounts
  alias MyHive.Accounts.User

  def call(user, message, device_id) when is_binary(device_id) do
    device = Accounts.find_by_device_id(device_id)
    deliver(device, device.os, message, user)
  end

  def call(user, message, device_id) when is_list(device_id) do
    User.notify_devices(user, message)
  end

  def call(user, message, device_id) when is_nil(device_id) do
    SmsMessage.send_message(user.phone_number, message)
  end

  defp deliver(device, os, message, _user) when os == "ios" do
    ApnsPostman.call(device.token, message)
  end

  defp deliver(_device, os, _message, _user) when os == "android" do
  end

end
