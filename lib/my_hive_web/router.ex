defmodule MyHiveWeb.Router do
  use MyHiveWeb, :router
  pipeline :browser do
    plug :accepts, ["html"]
    plug MyHiveWeb.Plugs.MaintenancePlug
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :only_office do
    plug :accepts, ["html"]
    plug MyHiveWeb.Plugs.MaintenancePlug
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :upload do
    plug :accepts, ["html"]
    plug MyHiveWeb.Plugs.MaintenancePlug
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :guest do
    plug MyHiveWeb.Plugs.MaintenancePlug
    plug :put_layout, {MyHiveWeb.LayoutView, :guest}
  end

  scope "/", MyHiveWeb.Shareables do
    pipe_through [:browser, :guest, MyHiveWeb.Plugs.ShareableDirectoryPlug]
    get "/shared/:token", ShareableController, :verify
    get "/shared/view/:token",ShareableController, :view
    get "/shared/:token/download", ShareableController, :download
    get "/shared/auth/:token", ShareableController, :auth_partial
    post "/shared/auth/:token", ShareableController, :authenticate
  end

  scope "/", MyHiveWeb do
    pipe_through [:upload]
    post "/upload/new", Api.V1.UploadController, :new
    head "/upload/new", Api.V1.UploadController, :new
  end

  scope "/", MyHiveWeb do
    pipe_through [:browser, MyHiveWeb.Plugs.Guest]
    get "/verify", VerificationController, :new
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/password/forgot", ForgottenPasswordController, :forgot
    post "/password/forgot", ForgottenPasswordController, :forgot
    get "/password/forgot/verify", ForgottenPasswordController, :forgot_verify
    get("/sessions/new/two_factor_auth", TwoFactorAuthController, :new)
    post("/sessions/new/two_factor_auth", TwoFactorAuthController, :create, session: [ :guardian_default_token ])
    get "/mobile_app/download/ios", MobileAppController, :ios
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
    get "/users/cv/:id/build", UserController, :cv
    get "/user/cv/:format/:user_id", Accounts.UserCvController, :cv
    patch "/users/cv", UserController, :update_fields
    resources "/users", UserController, only: [:index, :show, :edit, :delete, :update]
    live "/conversations/:conversation_id/users/:user_id", ConversationLive
    get "/change_password", PasswordController, :new
    put "/change_password", PasswordController, :update
    get "/token/refresh", SessionController, :refresh
    get "/logout", SessionController, :delete
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
    get "/settings", Settings.SettingsController, :index
    post "/settings/upload/logo", Settings.SettingsController, :upload_logo
    put "/settings",Settings.SettingsController, :update
    get "/case_folder_tree/new", Settings.CaseFolderTreeController, :new
    post "/case_folder_tree", Settings.CaseFolderTreeController, :create
    patch "/case_folder_tree/:id", Settings.CaseFolderTreeController, :activate
    delete "/case_folder_tree/:id", Settings.CaseFolderTreeController, :destroy
    patch "/app_module/:id/activate", Settings.AppModuleController, :activate
    patch "/app_module/:id/deactivate", Settings.AppModuleController, :deactivate
    get "/radiology_imports/:id/download", Radiology.RadiologyImportController, :download
    get "/chat", Chat.ChatController, :index
    get "/calendar", Calendar.CalendarController, :index
    get "/file_asset/chat/:message_id/attachment", FileManager.FileAssetController, :attachment
    get "/timesheet", TimeSheet.TimeSheetController, :index
    get "/time_sheet/export/pdf", TimeSheet.ExportController, :pdf
    get "/time_sheet/export/xlsx", TimeSheet.ExportController, :xlsx
    get "/newsfeed", Blog.BlogController, :index
    get "/blog/post/new", Blog.BlogController, :new
    post "/blog/post", Blog.BlogController, :create
    get "/blog/post/attachment/:id", Blog.BlogController, :attachment
    delete "/blog/post/attachment/:id/delete", Blog.BlogController, :destroy_attachment
    get "/blog/post/search", Blog.BlogController, :search
    get "/blog/post/:slug", Blog.BlogController, :show
    delete "/blog/post/:slug", Blog.BlogController, :destroy
    get "/archive", Archive.ArchiveController, :index
    get "/shared", FileManager.SharedFileController, :index
    get "/shared/view/internal/:id", FileManager.SharedFileController, :show
    get "/", PageController, :index
  end

  pipeline :jwt_authenticated do
    plug MyHive.Guardian.AuthPipeline
    plug MyHiveWeb.Plugs.DevicePlug
  end

  scope "/api/dt/v1", MyHiveWeb do
    pipe_through [:api, :jwt_authenticated]
    resources "/users", UsersDatatablesController, only: [:index]
  end

  scope "/api/v1", MyHiveWeb.Api.V1 do
    pipe_through [:api]
    post "/login", SessionController, :create
    post "/two_factor", SessionController, :two_factor_auth
    patch "/users/:id/mobile", Accounts.UserController, :update_mobile
  end

  scope "/api/v1" , MyHiveWeb do
    pipe_through [:api, :jwt_authenticated]
    resources "/medico_legal_cases", MedicoLegalCaseController, except: [:new, :edit, :delete]
    resources "/people", Api.V1.ContactBook.CasePersonController, except: [:new, :edit]
    patch "/medico_legal_cases/:id/disable_notification", MedicoLegalCaseController, :notification_off
    put "/medico_legal_cases/:id/update/:status", MedicoLegalCaseController, :status
    delete "/medico_legal_cases/:id", MedicoLegalCaseController, :delete
    get "/medico_legal_cases/:id",  MedicoLegalCaseController, :edit
    get "/users/search", UsersSearchController, :index
    get "/users/for_select", UsersSearchController, :for_select
    get "/users/all", UsersSearchController, :all
    get "/people/search/by_name", Api.V1.ContactBook.PersonSearchController, :index
    get "/folders/:id", Api.V1.FileManager.FoldersController, :show
    get "/folders/show_tree/:id", Api.V1.FileManager.FoldersController, :show_tree
    get "/folders/move_tree/:folder_id", Api.V1.FileManager.FoldersController, :move_tree
    patch "/folders/:id/move", Api.V1.FileManager.FoldersController, :move
    get "/folders/:id/ancestor", Api.V1.FileManager.FoldersController, :ancestor
    get "/archive", Api.V1.FileManager.FoldersController, :archive
    get "/shared", Api.V1.FileManager.FoldersController, :shared
    post "/folders", Api.V1.FileManager.FoldersController, :create
    post "/folders/download", Api.V1.FileManager.FoldersController, :download
    delete "/folders/:id",Api.V1.FileManager.FoldersController, :delete
    patch "/folders/:id",Api.V1.FileManager.FoldersController, :patch
    delete "/file_assets/:id",Api.V1.FileManager.FileAssetsController, :delete
    get "/file_assets/download/:id", Api.V1.FileManager.FileAssetsController, :show
    patch "/file_assets/:id",Api.V1.FileManager.FileAssetsController, :patch
    patch "/file_assets/:id/move",Api.V1.FileManager.FileAssetsController, :move
    post "/file_assets/decrypt", Api.V1.FileManager.FileAssetsController, :decrypt
    delete "/bulk_operation/delete_all", Api.V1.BulkOperationController, :delete_all
    delete "/bulk_operation/tidy_up", Api.V1.BulkOperationController, :tidy_up
    patch "/bulk_operation/mark_all", Api.V1.BulkOperationController, :mark_all
    post "/view_counts", Api.V1.Stats.ViewCountsController, :create
    get "/settings", Api.V1.SettingsController, :index
    get "/notifications/unread", Api.V1.NotificationController, :unread
    delete "/notifications/unread/all", Api.V1.NotificationController, :delete
    post "/shareable", Api.V1.Shareables.ShareableController, :create
    get "/modules/:account_id", Api.V1.SettingsController, :modules
    get "/radiology_imports/:id", Api.V1.Radiology.RadiologyImportController, :show
    delete "/radiology_imports/:id", Api.V1.Radiology.RadiologyImportController, :delete
    get "/chat_messages/:slug", Api.V1.Chat.ChatMessageController, :show
    get "/chat_rooms/:member_id", Api.V1.Chat.ChatRoomController, :index
    post "/chat_rooms", Api.V1.Chat.ChatRoomController, :create
    put "/chat_rooms/:id", Api.V1.Chat.ChatRoomController, :update
    delete "/chat_rooms/:id", Api.V1.Chat.ChatRoomController, :destroy
    get "/chat/:conversation_id/attachments", Api.V1.ChatUploadController, :index
    delete "/chat_rooms/:attachment_id/attachment", Api.V1.ChatUploadController, :destroy
    post "/time_sheet", Api.V1.TimeSheet.TimeEntryController, :create
    get "/time_sheet", Api.V1.TimeSheet.TimeEntryController, :index
    put "/time_sheet/:id", Api.V1.TimeSheet.TimeEntryController, :update
    delete "/time_sheet/:id", Api.V1.TimeSheet.TimeEntryController, :destroy
    post "/blog/post/upload", Api.V1.BlogUploadController, :upload
    get "/users", Api.V1.Accounts.UserController, :index
    get "/url/extraction/new", Api.V1.UrlExtractionController, :new
    post "/calendar_events", Api.V1.CalendarEventController, :create
    get "/calendar_events", Api.V1.CalendarEventController, :index
    get "/calendar_events/for_user/:user_id", Api.V1.CalendarEventController, :for_user
    delete "/calendar_events/:id", Api.V1.CalendarEventController, :destroy
    put "/calendar_events/:id", Api.V1.CalendarEventController, :update
    post "/upload/mobile",  Api.V1.UploadController, :mobile
    post "/mobile_device", Api.V1.Accounts.MobileDeviceController, :create
  end

  scope "/api/v1/files", MyHiveWeb do
    options "/",          Api.V1.UploadController, :options
    head  "/:uid", Api.V1.UploadController, :head
    post "/",             Api.V1.UploadController, :post
    patch "/:uid",        Api.V1.UploadController, :patch
    delete "/:uid",       Api.V1.UploadController, :delete
  end

  scope "/api/v1/chat_files", MyHiveWeb do
    options "/",          Api.V1.ChatUploadController, :options
    match :head, "/:uid", Api.V1.ChatUploadController, :head
    post "/",             Api.V1.ChatUploadController, :post
    patch "/:uid",        Api.V1.ChatUploadController, :patch
    delete "/:uid",       Api.V1.ChatUploadController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyHiveWeb do
  #   pipe_through :api
  # end
end
