defmodule MyHive.Time.TimeHelper do

  def time_ago(time) do
    Timex.format(time, "{relative}", :relative) |> Tuple.to_list |> List.last
  end

end
