defmodule MyHive.Notifications.MobileNotifier do
  alias MyHive.Repo
  alias MyHive.SmsNotifications.SmsMessage
  alias MyHive.Notifications.ApnsPostman

  def call(user, message) do
    user = Repo.preload(user, :mobile_devices)
    if (Enum.any?(user.mobile_devices)) do
      device = List.last(user.mobile_devices)
      deliver(device, device.os, message)
    else
      SmsMessage.send_message(user.phone_number, message)
    end
  end

  defp deliver(device, os, message) when os == "ios" do
    ApnsPostman.call(device.token, message)
  end

  defp deliver(_device, os, _message) when os == "android" do
  end

end
