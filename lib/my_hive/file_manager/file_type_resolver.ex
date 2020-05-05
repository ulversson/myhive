defmodule MyHive.FileManager.FileTypeResolver do
  alias MyHive.JsonLoader

  def call(filename) do
    if Enum.member?(all_extensions(), extension(filename)) do
      file_types()
       |> Enum.find(fn {_key, val} ->
          Enum.member?(val, extension(filename))
        end)
        |> elem(0)
    else
      "other"
    end
  end


  def extension(filename) do
    filename |> Path.extname |> String.replace(".","")
  end

  def file_types do
    JsonLoader.json_content("asset_categories.json")
  end

  def all_extensions() do
    file_types() |> Map.values |> List.flatten
  end
end
