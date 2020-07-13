defmodule MyHive.TimeSheet.Services.DurationCalculator do
  alias MyHive.TimeSheet.TimeEntry

  @one_minute 60
  @one_hour 3600

  def call(entries) do
    Enum.map(entries, fn en ->
      TimeEntry.duration_in_seconds(en) |> abs()
    end)
      |> sum_list()
      |> to_hh_mm()
  end

  def sum_list(list), do: Enum.reduce(list, 0, &(&1 + &2))

  def to_hh_mm(seconds) when seconds >= @one_hour do
    h = div(seconds, @one_hour)

    m =
      seconds
      |> rem(@one_hour)
      |> div(@one_minute)
      |> pad_int()

    "#{h}:#{m}"
  end

  def to_hh_mm(seconds) do
    div(seconds, @one_minute)
  end

  defp pad_int(int, padding \\ 2) do
    int
    |> Integer.to_string()
    |> String.pad_leading(padding, "0")
  end
end
