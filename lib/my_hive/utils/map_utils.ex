defmodule MyHive.Utils.MapUtils do
  def keys_to_atoms(json) when is_map(json) do
    Map.new(json, &reduce_keys_to_atoms/1)
  end

  def reduce_keys_to_atoms({key, val}) when is_map(val), do: {String.to_atom(key), keys_to_atoms(val)}
  def reduce_keys_to_atoms({key, val}) when is_list(val), do: {String.to_atom(key), Enum.map(val, &keys_to_atoms(&1))}
  def reduce_keys_to_atoms({key, val}) do
   {String.to_atom(to_string(key)), val}
  end
  
  defp replacement_for(key, tuple) do
    tuple
    |> Enum.find(fn {x, _} -> x == to_string(key) end)
    |> elem(1)
  end

  def replace_keys(map, tuple) do
    for {k, v} <- map, into: %{}, do: {replacement_for(k, tuple), v}
  end

end
