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
    get "/verify", VerificationController, :new
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get("/sessions/new/two_factor_auth", TwoFactorAuthController, :new)
    post("/sessions/new/two_factor_auth", TwoFactorAuthController, :create, session: [ :guardian_default_token ])
  end


  scope "/", MyHiveWeb do
    pipe_through [:browser, MyHiveWeb.Plugs.Auth, MyHiveWeb.Plugs.ForceSignOut]
    live "/users/new", UserLive.New, layout: {MyHiveWeb.LayoutView, :root}
    live "/users/:id/edit", UserLive.Edit, layout: {MyHiveWeb.LayoutView, :root}
    live "/conversations/:conversation_id/users/:user_id", ConversationLive
    get "/change_password", PasswordController, :new
    put "/change_password", PasswordController, :update
    delete "/logout", SessionController, :delete
    delete "/users/:id/mark_for_sign_out", SessionController, :mark_for_sign_out
    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :edit, :delete, :update]
    post "/verifications/:id/resend_instructions", VerificationController, :resend_instructions
    get "/medico_legal_cases/new/", CaseManagement.MedicoLegalCasesController, :new
    post "/medico_legal_cases", CaseManagement.MedicoLegalCasesController, :create
  end

  pipeline :jwt_authenticated do
    plug MyHive.Guardian.AuthPipeline
  end

  scope "/api/dt/v1", MyHiveWeb do
    pipe_through [:api, :jwt_authenticated]
    resources "/users", UsersDatatablesController, only: [:index]
  end

  scope "/api/v1" , MyHiveWeb do
    pipe_through [:api, :jwt_authenticated]
    resources "/medico_legal_cases", MedicoLegalCaseController, except: [:new, :edit]
    resources "/people", CaseManagement.CasePersonController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyHiveWeb do
  #   pipe_through :api
  # end
end
