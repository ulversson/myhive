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

  def uk_phone_formatter(phone_number) do 
    clean_phone = phone_number
      |> String.replace("-","") 
      |> String.replace("(","") 
      |> String.replace(")","")
    phone_parts = Regex.scan(~r/.{1,3}/, clean_phone)
    last_digits =  phone_parts 
      |> Enum.take(-2) 
      |> Enum.map(&Enum.join/1) 
      |> Enum.join("")  
    country = phone_parts 
      |> Enum.take(1)  |> Enum.join("") 
    middle = phone_parts
       |> tl 
       |> Enum.join("-") 
       |> String.slice(0..6)
    "(#{country}) #{middle}-#{last_digits}"
  end
end
