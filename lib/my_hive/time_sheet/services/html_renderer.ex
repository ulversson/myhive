defmodule MyHive.TimeSheet.Services.HtmlRenderer do

  import Phoenix.View

  def call(entries) do
    render_to_string(MyHiveWeb.TimeSheet.ExportView,
      "pdf.html", entries: entries)
  end

end
