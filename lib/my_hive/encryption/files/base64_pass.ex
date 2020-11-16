defmodule MyHive.Encryption.Base64Pass do

  def generate(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length) |> String.to_charlist
  end

  def write(length, path) do
    new_path = path |> Path.dirname()
      |> Path.expand()
      |> Path.absname
    save_path = write_path(new_path)
    File.write(save_path, generate(length))
    save_path
  end

  defp timestamp do
    Timex.now |> Timex.to_unix
  end

  defp write_path(path) do
    Path.join(path, filename())
  end

  defp filename() do
    "#{timestamp()}_pass.txt"
  end

end
