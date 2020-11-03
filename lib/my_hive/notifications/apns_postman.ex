defmodule MyHive.Notifications.ApnsPostman do

  alias Pigeon
  alias Pigeon.APNS

  def call(token, message) do
    notification_message(token, message) |> APNS.push()
  end

  def notification_message(token, message) do
    %APNS.Notification{
      device_token: token,
      expiration: nil,
      payload: %{"aps" => %{"alert" => message, "sound" => "alert"}},
      response: :success,
      topic: "co.uk.my-hive"
    }
  end

end
