defmodule MyHive.Chat.Services.ChatMissedCallNotifier do
  alias MyHive.{
    Accounts, Notifications
  }
  alias MyHiveWeb.Endpoint

  def call(sender_id, user_id) do
    recipient = user_id |> Accounts.get_user!()
    sender = sender_id |> Accounts.get_user!()
    Endpoint.broadcast!(
      "notification:#{recipient.id}",
      "new_notification",
      missed_call_notification(sender, recipient)
    )
  end

  defp missed_call_notification(sender, recipient) do
    Notifications.create(recipient, %{
      sender_id: sender.id,
      icon: "fas fa-phone-slash",
      show_on_arrival: true,
      topic: "Missed call from #{sender.first_name} #{sender.last_name}",
      body: "User #{sender.first_name} #{sender.last_name} tried to call you on myHive but you were not available at that time."
    })
  end
end
