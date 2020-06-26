defmodule MyHiveWeb.Blog.BlogController do
  use MyHiveWeb, :controller
  alias MyHive.Blog
  alias MyHive.Blog.Post
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root} when action not in [:create]
  action_fallback MyHiveWeb.FallbackController
  def index(conn, _params) do
    conn |> render("index.html")
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{}, %{})
    conn
      |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"post" => params}) do
    case Blog.create_post(params) do
      {:ok, post} ->
        conn
          |> put_flash(:info, "Your post have been successfully published")
          |> redirect(to: Routes.page_path(conn, :index))
      {:error, changeset} ->
        conn |> MyHiveWeb.FallbackController.call({:error, changeset})
    end
  end
end
