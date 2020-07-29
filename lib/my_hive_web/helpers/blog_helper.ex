defmodule MyHiveWeb.Helpers.BlogHelper do

  def post_author(post) do
    post.author.first_name <> " " <> post.author.last_name
  end

  def post_date(post) do
    post.inserted_at
      |> Timex.Timezone.convert("Europe/London")
      |> Timex.format!("%B %d, %Y at %H:%M", :strftime)
  end

  def has_attachments?(post) do
    Enum.any?(post.attachments)
  end

  def has_image_attachments?(post) do
    length(post_content_types(post, "image")) > 0
  end

  def has_video_attachments?(post) do
    length(post_content_types(post, "video")) > 0
  end

  def has_audio_attachments?(post) do
    length(post_content_types(post, "audio")) > 0
  end

  def first_attachment(post) do
    post.attachments |> Enum.at(0)
  end

  def first_attachment_link(post) do
    attachment = first_attachment(post)
    "/blog/post/attachment/#{attachment.id}"
  end
  def first_image_link(post) do
    image = first_image(post)
    "/blog/post/attachment/#{image.id}"
  end
  def first_image(post) do
    post
      |> post_content_types("image")
      |> Enum.at(0)
  end

  def first_video(post) do
    post
      |> post_content_types("video")
      |> Enum.at(0)
  end

  def first_audio(post) do
    post
      |> post_content_types("audio")
      |> Enum.at(0)
  end
  def first_video_link(post) do
    video = first_video(post)
    "/blog/post/attachment/#{video.id}"
  end

  def first_audio_link(post) do
    audio = first_audio(post)
    if (audio != nil) do
    "/blog/post/attachment/#{audio.id}"
    else
      ""
    end
  end

  def post_content_types(post, content_type) do
    filtered = Enum.filter(post.attachments, fn att ->
      att.content_type =~ content_type
    end)
    filtered
  end
end
