defmodule MyHiveWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :my_hive
  @session_options [
    store: :cookie,
    key: "_my_hive_key",
    signing_salt: "Vy51sIMk"
  ]
  socket "/socket", MyHiveWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :my_hive,
    gzip: true,
    only: ~w(css fonts images js audio favicon.ico robots.txt web build site.webmanifest my-hive-ios.ipa my-hive-android.apk maintenance.html)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [
      {:urlencoded,length: 90_000_000_000_000},
      {:multipart, length: 90_000_000_000_000},
      {:json, length: 90_000_000_000_000}
    ],
    length: 200_000_000_000,
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session, @session_options


  plug MyHiveWeb.Router
end
