defmodule MyHive.SmsNotifications.SmsMessage do

  alias ExTwilio.Message
  @from "my-hive"
  @account_sid "ACa4a18532638c2c2916dae995089c2d41"

  def send_message(recipient_number, body) do
    Message.create([to: recipient_number, from: @from,
      body: body, account_sid: @account_sid])
  end

  def send_passcode(user, passcode) do
    send_message(user.phone_number, passcode_text(passcode))
  end

  def passcode_text(passcode) do
    "Your Onetime Passcode is: #{passcode}"
  end

end
