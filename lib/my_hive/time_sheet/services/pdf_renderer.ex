defmodule MyHive.TimeSheet.Services.PdfRenderer do

  alias MyHive.TimeSheet.Services.HtmlRenderer

  def call(entries, is_ext) do
    HtmlRenderer.call(entries, is_ext)
    |> PdfGenerator.generate(
      page_size: "A4",
      shell_params: shell_params()
    )
  end

  def timestamp() do
    String.replace(current_time(), "/","_")
    |> String.replace(":","_")
    |> String.replace(" ","_")
  end

  defp shell_params do
  	["-O", "Landscape",
     "--footer-left","Created by myHive",
     "--footer-center", "[page] of [topage]",
     "--footer-right","Generated #{current_time()}"]
  end

  defp current_time do
    {_, time} = Timex.now("Europe/London")
      |> Timex.format("%m/%d/%Y %H:%m:%S", :strftime)
    time
  end



end
