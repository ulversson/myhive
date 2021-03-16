defmodule MyHive.Library.LibrarianConfig do 
  
  def librarian_config() do
    Application.get_env(:my_hive, MyHiveWeb.Endpoint)[:librarian]
  end

  def url do
    librarian_config()[:url]
  end

  def api_path do
    librarian_config()[:api_path]
  end

  def full_url do
    url() <> api_path()
  end
  
end