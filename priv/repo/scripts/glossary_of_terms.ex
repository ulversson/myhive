
alias MyHive.Reports
brackets_re = ~r/\(|\)/
file_lines = MyHive.JsonLoader.json_path("glossary.txt")
  |> File.read! 
  |> String.split("\n")

for line <- file_lines do 
  brackets_with_text = Regex.run(~r/\(.*?\)/, line) |> List.first
  short_name =  String.replace(brackets_with_text, brackets_re, "")
  lines_clean = String.replace(line, ~r/\(.*?\)/, "") |> String.split("-") |> Enum.map(&String.trim/1)
  Reports.create_glossary_item(%{
    name: (lines_clean |> hd),
    description: (lines_clean |> tl),
    short_name: short_name,
    letter: (lines_clean |> hd |> String.first)
  })
end