defmodule MyHive.WordUtils do

  def html_words(sentence) do
    sentence
      |> HtmlSanitizeEx.strip_tags()
      |> String.split(~r{(\\n|[^\w'])+})
      |> Enum.filter(fn x -> x != "" end)
  end

  def first_x_sentences(text, x) do
    text
      |> HtmlSanitizeEx.strip_tags()
      |> String.split(".")
      |> Enum.take(x)
      |> Enum.join()
  end

end
