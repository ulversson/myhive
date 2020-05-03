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
    delete "/users/:id/mark_for_sign_out", SessionController, :mark_for_sign_out
    resources "/users", UserController, only: [:index, :show, :edit, :delete, :update]
    live "/conversations/:conversation_id/users/:user_id", ConversationLive
    get "/change_password", PasswordController, :new
    put "/change_password", PasswordController, :update
    delete "/logout", SessionController, :delete
    post "/verifications/:id/resend_instructions", VerificationController, :resend_instructions
    get "/medico_legal_cases/new/", CaseManagement.MedicoLegalCasesController, :new
    post "/medico_legal_cases", CaseManagement.MedicoLegalCasesController, :create
    get "/people/partial/:partial_view", ContactBook.CasePersonController, :partial
    post "/medico_legal_cases/:id/status", CaseManagement.MedicoLegalCasesController, :status
    delete "/medico_legal_cases/:id", CaseManagement.MedicoLegalCasesController, :delete
    get "/medico_legal_cases/:id/edit", CaseManagement.MedicoLegalCasesController, :edit
    put "/medico_legal_cases/:id", CaseManagement.MedicoLegalCasesController, :update
    get "/folders", FileManager.FoldersController, :index
    post "/downloads/all", DownloadController, :all
    get "/downloads/:id", DownloadController, :show
    get "/", PageController, :index
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
    resources "/medico_legal_cases", MedicoLegalCaseController, except: [:new, :edit, :delete]
    resources "/people", Api.V1.ContactBook.CasePersonController, except: [:new, :edit]
    get "/users/search", UsersSearchController, :index
    get "/users/for_select", UsersSearchController, :for_select
    get "/people/search/by_name", Api.V1.ContactBook.PersonSearchController, :index
    get "/folders/:id", Api.V1.FileManager.FoldersController, :show
    post "/folders", Api.V1.FileManager.FoldersController, :create
    get "/downloads/:id", DownloadController, :show
  end

  scope "/api/v1/files", MyHiveWeb do
    options "/",          Api.V1.UploadController, :options
    post "/",             Api.V1.UploadController, :post
    delete "/:uid",       Api.V1.UploadController, :delete
    head "/:uid",         Api.V1.UploadController, :head
    patch "/:uid",        Api.V1.UploadController, :patch
end

  # Other scopes may use custom stacks.
  # scope "/api", MyHiveWeb do
  #   pipe_through :api
  # end
end
