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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
