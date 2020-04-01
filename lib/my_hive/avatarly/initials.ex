defmodule MyHive.Avatarly.Initials do 

  def get_initial(name) do
    clean_character =
      Regex.replace(~r/[\p{P}\p{S}\p{C}\p{N}]+/, name, "") 
      |> String.trim() 
      |> String.split()

    case Enum.count(clean_character) do
      0 ->
        "42"

      1 ->
        clean_character |> List.first() |> String.at(0) |> String.upcase()

      other ->
        first = clean_character |> List.first() |> String.at(0) |> String.upcase()
        last = clean_character |> List.last() |> String.at(0) |> String.upcase()
        first <> last
    end
  end

end  