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

config :ex_twilio, account_sid: {:system, "TW_ACCOUNT_SID"},
                   auth_token: {:system, "TW_ACCOUNT_TOKEN"}

try do                                     # wrap in "try do"
  File.stream!("./.env")                   # in case .env file does not exist.
    |> Stream.map(&String.trim_trailing/1) # remove excess whitespace
    |> Enum.each(fn line -> line           # loop through each line
    |> String.replace("export ", "")     # remove "export" from line
    |> String.split("=", parts: 2)       # split on *first* "=" (equals sign)
    |> Enum.reduce(fn(value, key) ->
      System.put_env(key, value)         # set each environment variable
    end)
  end)
  rescue
    _ -> IO.puts "no .env file found!"
end

                 # Set the Encryption Keys as an "Application Variable" accessible in aes.ex
config :my_hive, MyHive.Encryption.AES,
  keys: System.get_env("ENCRYPTION_KEYS") # get the ENCRYPTION_KEYS env variable
    |> String.replace("'", "")  # remove single-quotes around key list in .env
    |> String.split(",")        # split the CSV list of keys
    |> Enum.map(fn key -> :base64.decode(key) end) # decode the key.

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :my_hive, MyHive.Guardian,
       issuer: "my_hive",
       ttl: { 30, :days},
       verify_module: Guardian.JWT,
       secret_key: "A1eajRxbefshwZvqLM6NZB8ioCJIQ9nsmX09YBz0WWM6RJYkCPdEwuaDkHqOvbOY"

config :my_hive, MyHive.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  port: 587,
  username:  "info@my-hive.co.uk",
  password:  {:system, "EMAIL_PASS"},
  tls: :if_available, # can be `:always` or `:never`
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"], # or {":system", ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
  ssl: false, # can be `true`
  retries: 1

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

config :my_hive, MyHiveWeb.Endpoint,
live_view: [
  signing_salt: "Q77WhzLByn3g7+IdX6ojJT/oNkgAEWhEuITRrfMOJO+BRc5lTMzSXFoo0wtP7Foe"
]

config :tus, controllers: [
  MyHiveWeb.Api.V1.UploadController,
  MyHiveWeb.Api.V1.ChatUploadController
]
#/raid/deployer/back/00MXCB_20201026_Mon_26_Oct_2020/files/7/e/1
config :tus, MyHiveWeb.Api.V1.UploadController,
  storage: Tus.Storage.Local,
  base_path: "/raid/deployer/back/00MXCB_20201102_Mon_02_Nov_2020/files",
  cache: Tus.Cache.Redis,
  max_size: 5368709120
#
config :tus, MyHiveWeb.Api.V1.ChatUploadController,
  storage: Tus.Storage.Local,
  base_path: "/raid/deployer/back/00MXCB_20201102_Mon_02_Nov_2020/chat_files",
  cache: Tus.Cache.Memory,
  max_size: 5368709120
config :joken, default_signer: "eJj_PdUuCbVXxtSwiOpLkJEj5K-OncKnwT44rfFQOKE"

config :mix_systemd,
  base_dir: "/home/deployer/apps/myhive/current/_build/prod/rel/my_hive",
  # Set individual env vars
  env_vars: [
    "PORT=4000",
    "DEFAULT_ACCOUNT=McCollum Consultants"
  ],
  # Run app under this OS user, default is name of app
  app_user: "deployer",
  app_group: "deployer"

  config :mix_deploy,
  # Generate runtime scripts from templates
  templates: [
    # Systemd wrappers
    "start",
    "stop",
    "restart",
    "enable",

    # System setup
    "create-users",
    "create-dirs",
    "set-perms",

    # Local deploy
    "init-local",
    "copy-files",
    "release",
    "rollback",

    # DB migrations
    "migrate"
  ],
  app_user: "deployer",
  app_group: "deployer"

  config :my_hive, MyHive.Scheduler,
  jobs: [
    {"@daily", {MyHiveWeb.Plugs.SharingDirectoryPurger, :call, []}},
    {"@daily", {MyHive.CaseManagement.MedicoLegalCaseReminder, :call, []}},
  ]

config :my_hive, MyHiveWeb.Endpoint,
  radiology: [
  host: "localhost",
  port: 8042,
  username: "dicomadmin",
  password: "dicompassword",
  browser: "dicom.my-hive.pl"
]

config :pigeon, :apns,
  apns_default: %{
    key: "config/AuthKey_SD7Q73HN5W.p8",
    key_identifier: "SD7Q73HN5W",
    team_id: "64D88AWZWZ",
    mode: :dev
  }

config :briefly, default_extname: ".html"
