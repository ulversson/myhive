defmodule MyHive.TimeSheet.Services.HtmlRenderer do

  import Phoenix.View

  def call(entries, is_ext) do
    render_to_string(MyHiveWeb.TimeSheet.ExportView,
      "pdf.html",
        entries: entries,
        extended: is_ext
      )
  end

end
