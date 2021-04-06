defmodule MyHive.Regex.Replacer do
  def replace_n(str, n, pat, subst) do
    {back, front} =
      str
      |> String.split(pat)
      |> Enum.reverse()
      |> Enum.split(n+1)
    back = Enum.join(back, subst)

    [back | front]
    |> Enum.reverse()
    |> Enum.join(pat)
  end
end