
defmodule GlossaryOfTermsImporter do
  
  alias MyHive.Reports
  @brackets_re  ~r/\(|\)/

  def call() do
    file_lines = MyHive.JsonLoader.json_path("glossary.txt")
      |> File.read! 
      |> String.split("\n")

    for line <- file_lines do 
      brackets_with_text = Regex.run(~r/\(.*?\)/, line) 
      lines_clean = String.replace(line, ~r/\(.*?\)/, "") |> String.split("-") |> Enum.map(&String.trim/1)
      short_name = short_name(brackets_with_text)
      res = Reports.create_glossary_item(%{
        name: (lines_clean |> hd),
        description: Enum.slice(lines_clean, 1, length(lines_clean)-1) |> Enum.join("-"),
        short_name: short_name(brackets_with_text),
        letter: (lines_clean |> hd |> String.first)
      })
    end
  end

  def short_name(item) when is_nil(item) do
    ""
  end

  def short_name(item) when is_nil(item) == false do 
    case List.first(item) do
     nil -> ""
     _ -> String.replace(List.first(item), @brackets_re, "")
    end
  end
end

GlossaryOfTermsImporter.call()