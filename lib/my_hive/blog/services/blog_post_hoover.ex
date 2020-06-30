defmodule MyHive.Blog.Services.BlogPostHoover do
  alias MyHive.{
    Repo, Blog
  }

  def call(blog_post) do
    Repo.transaction(fn ->
      Blog.delete_post_tags(blog_post)
      Blog.delete_post(blog_post)
      Enum.each(blog_post.attachments, fn file ->
        File.rm(file.path)
        Repo.delete(file)
      end)
    end)
  end
end
