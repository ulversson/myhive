defmodule MyHive.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_hive,
      version: "0.1.0",
      prod: [
        include_executables_for: [:unix],
        steps: [:assemble, :tar]
      ],
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MyHive.Application, []},
      extra_applications: [:logger, :runtime_tools, :timex, :inets, :sizeable]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.11"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:mix_deploy, "~> 0.7"},
      {:mix_systemd, "~> 0.7"},
      {:phoenix_html, "~> 2.11"},
      {:mime, "~> 1.2"},
      {:scrivener_ecto, "~> 2.3"},
      {:aes_crypt, "~> 0.1.0"},
      {:comeonin, "~> 4.0"},
      {:browser, "~> 0.4.4"},
      {:tus, "~> 0.1.0"},
      {:briefly, "~> 0.3"},
      {:tus_cache_redis, "~> 0.1.0"},
      {:html_sanitize_ex, "~> 1.3.0-rc3"},
      {:floki, "~> 0.28.0"},
      {:redix, "~> 0.7.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:bamboo, "~> 1.4"},
      {:rambo, "~> 0.3"},
      {:pigeon, "~> 1.5.1"},
      {:kadabra, "~> 0.4.4"},
      {:ecto_autoslug_field, "~> 2.0"},
      {:paginator, "~> 0.6"},
      {:argon2_elixir, "~> 1.3"},
      {:bamboo_smtp, "~> 2.1.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},
      {:gettext, "~> 0.11"},
      {:timex, "~> 3.5"},
      {:joken, "~> 2.0"},
      {:quantum, "~> 3.0-rc"},
      {:arbor, "~> 1.1.0"},
      {:mogrify, "~> 0.7.4"},
      {:librex, "~> 1.0"},
      {:distillery, "~> 2.0"},
      {:excal, "~> 0.3.2"},
      {:image64, "~> 0.0.1"},
      {:guardian_trackable, "~> 0.2.0"},
      {:guardian, "~> 1.1"},
      {:pot, "~> 0.9.6"},
      {:jason, "~> 1.0"},
      {:elixlsx, "~> 0.4.2"},
      {:ua_parser, "~> 1.8"},
      {:pdf_generator, ">=0.6.0" },
      {:ex_twilio, "~> 0.8.1"},
      {:plug_cowboy, "~> 2.0"},
      {:task_after, "~> 1.0.0"},
      {:sizeable, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
