# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :my_hive,
  ecto_repos: [MyHive.Repo]

# Configures the endpoint
config :my_hive, MyHiveWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5idmIg+0nN38ALE5tW4i/Xbq4akwlLgw2/D3Gx7exa4ArW4y61PQBJxKMyl0iz9c",
  render_errors: [view: MyHiveWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MyHive.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_twilio, account_sid: "ACa4a18532638c2c2916dae995089c2d41",
                   auth_token: "d6b1e0b76f4b83c68943f72bde2dacd1" 

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :my_hive, MyHive.Guardian,
       issuer: "my_hive",
       ttl: { 30, :days},
       verify_module: Guardian.JWT,     
       secret_key: "A1eajRxbefshwZvqLM6NZB8ioCJIQ9nsmX09YBz0WWM6RJYkCPdEwuaDkHqOvbOY"
