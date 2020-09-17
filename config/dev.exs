use Mix.Config

# Configure your database
config :my_hive, MyHive.Repo,
  username: "myhive",
  password: "myhive",
  database: "myhive_prod",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :my_hive, MyHiveWeb.Endpoint,
  http: [port: 4000, ip: {0,0,0,0}],
  https: [
    port: 443,
    ip: {0,0,0,0},
    keyfile: "priv/keys/localhost.key",
    certfile: "priv/keys/localhost.cert"
  ],
  url: [host: "212.159.16.227"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :my_hive, MyHiveWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/my_hive_web/{live,views}/.*(ex)$",
      ~r"lib/my_hive_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
config :my_hive, MyHiveWeb.Endpoint,
  blog_storage_root: "/tmp"

config :tus, MyHiveWeb.Api.V1.UploadController,
  storage: Tus.Storage.Local,
  base_path: "priv/static/files/",
  cache: Tus.Cache.Memory,
  max_size: 5368709120

config :tus, MyHiveWeb.Api.V1.ChatUploadController,
  storage: Tus.Storage.Local,
  base_path: "priv/static/chat_files/",
  cache: Tus.Cache.Redis,
  max_size: 5368709120

config :my_hive, :environment, :dev
