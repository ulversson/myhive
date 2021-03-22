defmodule MyHive.Library.LibrarianConfig do 
  
  alias MyHive.Accounts
  
  def librarian_config() do
    Application.get_env(:my_hive, MyHiveWeb.Endpoint)[:librarian]
  end

  def url do
    System.get_env("LIB_URL")
  end

  def api_path do
    librarian_config()[:api_path]
  end

  def full_url do
    url() <> api_path()
  end
  
  def lib_token(user) do
    if Accounts.is_admin_or_super_admin?(user) do
      System.get_env("LIB_TOKEN")
    else
      ""
    end
  end
end