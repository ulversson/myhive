defmodule MyHive.Organizer.Services.DateRecurrenceCalculator do

  alias Excal.Recurrence.Stream

  def call(start_date, rrule, take) when is_integer(take) do
    {:ok, stream} = Stream.new(rrule, start_date)
    stream |> Enum.take(take)
  end

  def call(start_date, end_date, rrule) do
    options = [from: start_date, until: end_date]
    {:ok, stream} = Stream.new(rrule, start_date, options)
    Enum.to_list(stream)
  end

end
