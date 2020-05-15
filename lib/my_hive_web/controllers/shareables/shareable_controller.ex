defmodule MyHiveWeb.Shareables.ShareableController do
  use MyHiveWeb, :controller
  alias MyHive.Shareable

  def verify(conn, %{"token" => token}) do
    dir = Shareable.get_directory_by_token(token)
  end
end
