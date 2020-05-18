defmodule MyHiveWeb.Router do
  use MyHiveWeb, :router
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :only_office do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :guest do
    plug :put_layout, {MyHiveWeb.LayoutView, :guest}
  end

  scope "/", MyHiveWeb.Shareables do
    pipe_through [:browser, :guest, MyHiveWeb.Plugs.ShareableDirectoryPlug]
    get "/shared/:token", ShareableController, :verify
    get "/shared/view/:token",ShareableController, :view
    get "/shared/:token/download", ShareableController, :download
  end

  scope "/", MyHiveWeb do
    pipe_through [:browser, MyHiveWeb.Plugs.Guest]
    get "/verify", VerificationController, :new
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get("/sessions/new/two_factor_auth", TwoFactorAuthController, :new)
    post("/sessions/new/two_factor_auth", TwoFactorAuthController, :create, session: [ :guardian_default_token ])
  end

  scope "/", MyHiveWeb.FileManager do
    pipe_through [:only_office, MyHiveWeb.Plugs.OnlyOfficePlug]
    get "/only_office/:user_id/asset/:id", DocumentProviderController, :only_office_asset
    post "/only_office/:id/callback", DocumentProviderController, :only_office_callback
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
    get "/file_asset/:id", FileManager.FileAssetController, :show
    get "/only_office/:id", FileManager.DocumentProviderController, :only_office
    get "/profile", Profile.ProfileController, :show
    put "/profile",Profile.ProfileController, :update
    get "/notifications/:id", Notifications.NotificationController, :show
    post "/quick_links", Accounts.QuickLinksController, :create
    get "/quick_links/new", Accounts.QuickLinksController, :new
    delete "/quick_links/:id", Accounts.QuickLinksController, :destroy
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
    get "/folders/show_tree/:id", Api.V1.FileManager.FoldersController, :show_tree
    post "/folders", Api.V1.FileManager.FoldersController, :create
    post "/folders/download", Api.V1.FileManager.FoldersController, :download
    delete "/folders/:id",Api.V1.FileManager.FoldersController, :delete
    patch "/folders/:id",Api.V1.FileManager.FoldersController, :patch
    delete "/file_assets/:id",Api.V1.FileManager.FileAssetsController, :delete
    patch "/file_assets/:id",Api.V1.FileManager.FileAssetsController, :patch
    delete "/bulk_operation/delete_all", Api.V1.BulkOperationController, :delete_all
    patch "/bulk_operation/mark_all", Api.V1.BulkOperationController, :mark_all
    post "/view_counts", Api.V1.Stats.ViewCountsController, :create
    get "/settings", Api.V1.SettingsController, :index
    get "/notifications/unread", Api.V1.NotificationController, :unread
    post "/shareable", Api.V1.Shareables.ShareableController, :create
    get "/shareable/grant/:id", Api.V1.Shareables.ShareableController, :grant
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
