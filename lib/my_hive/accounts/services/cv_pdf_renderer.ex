defmodule MyHive.Accounts.Services.CvPdfRenderer do

  alias MyHive.Accounts.Services.CvHtmlRenderer

  def call(fields) do
    CvHtmlRenderer.call(fields)
    |> PdfGenerator.generate(
      page_size: "A4",
      shell_params: shell_params(fields)
    )
  end

  def timestamp() do
    String.replace(current_time(), "/","_")
    |> String.replace(":","_")
    |> String.replace(" ","_")
  end

  defp shell_params(fields) do
    ["-O", "Portrait",
     "--header-font-size", "34",
     "--header-spacing", "10",
     "-T", "40mm",
     "--header-left", name_field(fields).field_value,
     "--footer-center", "[page] of [topage]",
     "--footer-right","Generated #{current_time()}"]
  end

  defp current_time do
    {_, time} = Timex.now("Europe/London")
      |> Timex.format("%m/%d/%Y %H:%m:%S", :strftime)
    time
  end

  defp name_field(fields) do
    Enum.filter(fields, fn ufield ->
      ufield.cv_field.name == "Name"
    end) |> List.first
  end


end
