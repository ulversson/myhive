defmodule MyHiveWeb.Blog.BlogController do
  use MyHiveWeb, :controller
  alias MyHive.Blog
  alias MyHive.Blog.{
    Post, BlogSearch
  }
  alias MyHive.Blog.Services.{
    BlogImageThumbnailer,
    BlogPostHoover
  }

  plug :put_root_layout, {MyHiveWeb.LayoutView, :root} when action not in [:create]
  action_fallback MyHiveWeb.FallbackController
  def index(conn, params) when map_size(params) == 0 do
    conn |> render(
      "index.html",
      posts: Blog.all_posts(),
      aname: "index",
      tags: Blog.top_tags()
    )
  end

  def index(conn, %{"tag" => tag_name}) when is_binary(tag_name) do
    conn |> render(
      "index.html",
      posts: Blog.by_tag(tag_name),
      aname:  "index",
      tags: Blog.top_tags()
    )
  end

  def search(conn, %{"q" => keyword}) when is_binary(keyword) and keyword != "" do
    query = Blog.all_posts_query()
    results = BlogSearch.run(query, keyword)
    conn |> render(
      "index.html",
      posts: results,
      aname: "search",
      tags: Blog.top_tags()
    )
  end

  def search(conn, %{"q" => keyword}) when keyword == "" do
    conn |> render(
      "index.html",
      posts: Blog.all_posts(),
      tags: Blog.top_tags(),
      aname:  "search"
    )
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{}, %{})
    conn
      |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"post" => params}) do
    case Blog.create_post(params) do
      {:ok, _post} ->
        conn
          |> put_flash(:info, "Your post have been successfully published")
          |> redirect(to: Routes.page_path(conn, :index))
      {:error, changeset} ->
        conn |> MyHiveWeb.FallbackController.call({:error, changeset})
    end
  end

  def attachment(conn, %{"id" => id} = params) when map_size(params) == 3 do
    attachment = Blog.get_attachment!(id)
    conn
    |> send_download(
      {:file, BlogImageThumbnailer.output_path(attachment)},
      filename: attachment.filename,
      content_type: attachment.content_type,
      disposition: :inline,
      charset: "utf-8"
    )
  end

  def attachment(conn, %{"id" => id} = params) when map_size(params) == 1 or map_size(params) == 2 do
    attachment = Blog.get_attachment!(id)
    disposition = if params["disposition"] == "inline", do: :inline, else: :attachment
    conn
    |> send_download(
      {:file, attachment.path},
      filename: attachment.filename,
      content_type: attachment.content_type,
      disposition: disposition,
      charset: "utf-8"
    )
  end

  def destroy_attachment(conn, %{"id" => id}) do
    attachment = Blog.get_attachment!(id)
    File.rm(attachment.path)
    Blog.delete_attachment(attachment)
    conn |> json(%{
      status: "ok",
      message: "Attachment removed"
    })
  end

  def show(conn, %{"slug" => slug}) do
    post = Blog.get_post_by_slug!(slug)
    conn |> render("show.html",
      tags: Blog.top_tags(),
      post: post
    )
  end

  def destroy(conn, %{"slug" => slug}) do
    post = Blog.get_post_by_slug!(slug)
    BlogPostHoover.call(post)
    conn |> json(%{
      status: "ok",
      message: "Post has been removed"
    })
  end

end
