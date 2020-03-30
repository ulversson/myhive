defmodule MyHiveWeb.Router do
  use MyHiveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyHiveWeb do
    pipe_through [:browser, MyHiveWeb.Plugs.Guest]

    resources "/register", UserController, only: [:create, :new]
    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end


  scope "/", MyHiveWeb do
    pipe_through [:browser, MyHiveWeb.Plugs.Auth]

    delete "/logout", SessionController, :delete

    get "/", PageController, :index
    get "/show", PageController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyHiveWeb do
  #   pipe_through :api
  # end
end