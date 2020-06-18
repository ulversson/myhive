defmodule MyHive.FileManager.Icons do

  alias MyHive.JsonLoader
  def get_all() do
    JsonLoader.json_content("icons.json")
  end

  def get(key) do
    get_all()[key]
  end

  def get_from_filename(filename) when is_binary(filename) do
    atom_ext = filename |> Path.extname() |> String.replace(".","") |> String.to_atom
    ":" <> Atom.to_string(atom_ext) |> get()
  end

  def get_from_filename(filename) when is_nil(filename) do
  end
end
