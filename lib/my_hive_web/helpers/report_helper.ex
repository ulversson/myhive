defmodule MyHiveWeb.Helpers.ReportHelper do 
  
  alias MyHive.Regex.Replacer
  
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

  def time_format(_items, _item, index) when index == 0 do
    "%d %B %Y"
  end

  def time_format(_items, _item, index) when index > 0  do
    "%d %B %Y"
  end
  
  def item_without_starting_ending_div(content) do
    if String.starts_with?(content, "<div>") and String.ends_with?(content, "</div>") do
      String.replace(content, "<div><br></div>", "", global: true)
        |> String.replace_leading("<div>", "")
        |> String.replace_trailing("</div>","")
    else
      content
    end
  end
  

end