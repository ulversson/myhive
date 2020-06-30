defmodule MyHiveWeb.Api.V1.UrlExtractionController do
  use MyHiveWeb, :controller
  import MyHive.Regex.RegularExpressions
  alias MyHive.Blog.Services.BlogCrawlerService

  def new(conn, %{"url" => url}) do
    if String.match?(url, http_https) do
      crawl_res = BlogCrawlerService.call(url)
      conn |> json(%{
        status: "ok",
        title: crawl_res.title,
        url: url,
        image: crawl_res.image,
        image64: BlogCrawlerService.url_to_base64(crawl_res.image),
        description: crawl_res.description
      })
    else
      conn
        |> put_status(422)
        |> text("Invalid URL")
    end
  end
end
