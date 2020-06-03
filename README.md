# MyHive
mix systemd.init
mix systemd.generate

mix deploy.init
mix deploy.generate
bin/build

# Extract release to target directory on local machine, creating current symlink
bin/deploy-release

# Run database migrations
bin/deploy-migrate

# Restart the systemd unit
sudo bin/deploy-restart
# NEW_KEY = 
```:crypto.strong_rand_bytes(32) |> :base64.encode```


# ENCRYPTION KEYS

echo "export ENCRYPTION_KEYS='nMdayQpR0aoasLaq1g94FLba+A+wB44JLko47sVQXMg=,L+ZVX8iheoqgqb22mUpATmMDsvVGtafoAeb0KN5uWf0='" >> .env && echo ".env" >> .gitignore

# SEED

1/ Account
2/ Chat
3/ Folder tree
4/ Doc prov
5/

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

# INSTALL JANUS

MAC:
brew install jansson libnice openssl srtp libusrsctp libmicrohttpd \
	libwebsockets cmake rabbitmq-c sofia-sip opus libogg curl glib \
	libconfig pkg-config gengetopt autoconf automake libtool

  