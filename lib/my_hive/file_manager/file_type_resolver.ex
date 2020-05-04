defmodule MyHive.FileManager.FileTypeResolver do
  alias MyHive.JsonLoader

  def call(filename) do
    file_types()
      |> Enum.find(fn {_key, val} ->
        Enum.member?(val, extension(filename))
       end)
      |> elem(0)
  end

  defp extension(filename) do
    filename |> Path.extname |> String.replace(".","")
  end

  defp file_types do
    JsonLoader.json_content("asset_categories.json")
  end
end
