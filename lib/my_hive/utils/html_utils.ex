defmodule MyHive.HtmlUtils do

  def has_image?(html) do
    imgs = html |> doc() |> images()
    length(imgs) > 0
  end

  def first_image_src(html) do
    html
      |> doc()
      |> images()
      |> List.first
      |> Tuple.to_list
      |> List.flatten
      |> tl
      |> hd
      |> Tuple.to_list
      |> tl
      |> List.first
  end

  defp doc(html) do
    {:ok, doc} = Floki.parse_document(html)
    doc
  end

  defp images(doc) do
    Floki.find(doc, "img")
  end

end
