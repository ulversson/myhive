defmodule MyHive.Blog.Services.BlogImageThumbnailer do
  import Mogrify
  @thumbnail_size "200x150"

  def call(attachment) do
    open(attachment.path)
      |> resize_to_limit(thumbnail_size())
      |> save(path: output_path(attachment))
  end

  def output_path(attachment) do
    directory_to_save(attachment.path) <> "/" <> "thumb_#{attachment.filename}"
  end

  defp thumbnail_size() do
    @thumbnail_size
  end

  defp directory_to_save(path) when is_binary(path) do
    Path.dirname(path)
  end

  defp directory_to_save(path) when is_nil(path) do
    ""
  end
end
