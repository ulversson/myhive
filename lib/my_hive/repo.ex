defmodule MyHive.Repo do
  use Ecto.Repo,
    otp_app: :my_hive,
    adapter: Ecto.Adapters.Postgres
end
