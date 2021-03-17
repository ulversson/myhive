defmodule MyHive.CORS do
  use Corsica.Router,
    origins: ["http://localhost", ~r{^https?://(.*\.)?my-hive\.co\.uk$}],
    allow_credentials: true,
    max_age: 600

  resource "/public/*", origins: "*"
  resource "/*"
end