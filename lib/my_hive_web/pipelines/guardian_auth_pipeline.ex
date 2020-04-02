defmodule MyHive.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :my_hive,
  module: MyHive.Guardian,
  error_handler: MyHive.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end