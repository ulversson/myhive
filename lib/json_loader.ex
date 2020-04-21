defmodule MyHive.JsonLoader do
  def get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Poison.decode(body), do: {:ok, json}
  end

  def json_path(json_file) do
    Path.join(:code.priv_dir(:my_hive), "data/#{json_file}")
  end

  def json_content(file_name) do
    {:ok, res} = file_name |> json_path |> get_json
    res
  end
end
