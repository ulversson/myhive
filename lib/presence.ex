defmodule MyHiveWeb.Presence do
  use Phoenix.Presence, otp_app: :my_hive,
                        pubsub_server: MyHive.PubSub
end
