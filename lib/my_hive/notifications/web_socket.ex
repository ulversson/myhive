defmodule MyHive.Notifications.WebSocket do
  defstruct [:topic, :event, :payload]
end
defimpl MyHive.Notifications.NotificationProtocol,
  for: MyHive.Notifications.WebSocket do
  alias MyHiveWeb.Endpoint

  def send(n) do
    Endpoint.broadcast!(n.topic, n.event, n.payload)
  end
end
