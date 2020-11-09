defmodule MyHive.Notifications.ApnsPostman do

  alias Pigeon
  alias Pigeon.APNS

  def call(token, message) do
    notification_message(token, message) |> APNS.push()
  end

  def notification_message(token, message) do
    %APNS.Notification{
      device_token: token,
      expiration: expiration_date(),
      payload: %{"aps" => %{"alert" => message, "sound" => "default"}},
      response: :success,
      topic: "co.uk.my-hive"
    }
  end

  defp expiration_date() do
    Timex.now("Europe/London") |> Timex.shift(days: 1) |> Timex.to_unix
  end

end
