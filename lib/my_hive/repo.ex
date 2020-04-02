defmodule MyHive.Repo do
  use Scrivener, page_size: 25
  use Ecto.Repo,
    otp_app: :my_hive,
    adapter: Ecto.Adapters.Postgres
end
