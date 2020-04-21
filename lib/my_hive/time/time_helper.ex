defmodule MyHive.Time.TimeHelper do

  def time_ago(time) do
    Timex.format(time, "{relative}", :relative) |> Tuple.to_list |> List.last
  end

  def to_date(string) do
    string
      |> String.replace("/","-")
      |> String.split("-")
      |> Enum.reverse |> Enum.join("-")
      |> Date.from_iso8601!
  end

  def update_date_in_map(map, date_field) do
    Map.put(map, date_field, to_date(map[date_field]))
  end
end
