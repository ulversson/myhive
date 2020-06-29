defmodule MyHiveWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use MyHiveWeb, :controller
      use MyHiveWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: MyHiveWeb
      import Plug.Conn
      import MyHiveWeb.Gettext
      import MyHiveWeb.Plugs.ApiAuth
      import Phoenix.LiveView.Controller
      alias MyHiveWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/my_hive_web/templates",
        namespace: MyHiveWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]
      use Phoenix.HTML
      import MyHive.Accounts.Auth, only: [signed_in?: 1]
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]
      import MyHiveWeb.Helpers.ViewHelper
      import Phoenix.LiveView.Controller, only: [live_render: 2, live_render: 3]
      import Phoenix.LiveView.Helpers
      import MyHiveWeb.Plugs.ApiAuth
      import MyHive.Time.TimeHelper
      import MyHiveWeb.Helpers.ProfileHelper
      import MyHiveWeb.ErrorHelpers
      import MyHiveWeb.Gettext
      import MyHiveWeb.Helpers.BlogHelper
      alias MyHiveWeb.Router.Helpers, as: Routes
    end
  end

  @spec router :: {:__block__, [], [{:import, [...], [...]} | {:use, [...], [...]}, ...]}
  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import MyHiveWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
