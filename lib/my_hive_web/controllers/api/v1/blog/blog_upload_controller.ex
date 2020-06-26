defmodule MyHiveWeb.Api.V1.BlogUploadController do
  use MyHiveWeb, :controller
  alias MyHive.Blog.Services.BlogAllocator

  def upload(conn, %{"files" => files}) do
    user = conn.private.guardian_default_resource
    db_files = BlogAllocator.call(files, user.id)
    conn |> json(db_files)
  end
end
