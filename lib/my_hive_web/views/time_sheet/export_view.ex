defmodule MyHiveWeb.TimeSheet.ExportView do
  use MyHiveWeb, :view
  alias MyHive.TimeSheet.Services.XLSXRenderer

  def render("export.xlsx", %{entries: entries}) do
    XLSXRenderer.call(entries)
      |> Elixlsx.write_to_memory("report.xlsx")
      |> elem(1)
      |> elem(1)
  end

end
