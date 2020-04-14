defmodule MyHiveWeb.Router do
  use MyHiveWeb, :router
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyHiveWeb do
    pipe_through [:browser, MyHiveWeb.Plugs.Guest]

    #resources "/register", UserController, only: [:create, :new]

    get "/verify", UserController, :verify_email
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get("/sessions/new/two_factor_auth", TwoFactorAuthController, :new)
    post("/sessions/new/two_factor_auth", TwoFactorAuthController, :create, session: [ :guardian_default_token ])
  end


  scope "/", MyHiveWeb do
    pipe_through [:browser, MyHiveWeb.Plugs.Auth]
    live "/users/new", UserLive.New, layout: {MyHiveWeb.LayoutView, :root}

    live "/conversations/:conversation_id/users/:user_id", ConversationLive
    delete "/logout", SessionController, :delete

    get "/", PageController, :index
    get "/show", PageController, :show
    resources "/users", UserController
  end

  pipeline :jwt_authenticated do
    plug MyHive.Guardian.AuthPipeline
  end

  scope "/api/dt/v1", MyHiveWeb do
    pipe_through [:api, :jwt_authenticated]
    resources "/users", UsersDatatablesController, only: [:index]
 end

  # Other scopes may use custom stacks.
  # scope "/api", MyHiveWeb do
  #   pipe_through :api
  # end
end
