defmodule MyHiveWeb.Helpers.ReportHelper do 

  def item_header(item, index) do
    String.replace(item.header, ~r/\d/, "") <> "#{index+1}"
  end

  def no_space_content(item) do
    item.content 
      |> String.replace("<div><br></div>","")
      |> String.replace("<br>", "") 
      |> String.trim() 
      |> String.replace("&nbsp;", "")
  end

  def full_date(items, item, index) do
    Timex.format(item.occurred_on, time_format(items, item, index), :strftime) 
      |> elem(1)
  end

  def time_empty?(item) do
    is_nil(item.timestamp) || item.timestamp == "HH:mm"
  end

  def full_time(item) do
    if (time_empty?(item)) , do: "", else: ", "<> item.timestamp <> "hours"
  end

  def timestamp(items, item, index) do
    "<strong>" <> full_date(items, item, index) <> full_time(item) <> "</strong> - "
  end

  def time_format(items, item, index) when index == 0 do
    "%d %B %Y"
  end

  def time_format(items, item, index) when index > 0  do
    if (index + 1 == length(items)) do 
      "%d %B %Y"
    else
      prev_item = Enum.at(items, index-1) |> elem(0)
      if is_nil(prev_item.occurred_on) do 
        "%d %B %Y"
      else
        if (prev_item.occurred_on.year == item.occurred_on.year) do
          "%d %B"
        else
          "%d %B %Y"
        end
      end
    end
  end

end