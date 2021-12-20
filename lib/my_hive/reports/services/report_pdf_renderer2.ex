defmodule MyHive.Reports.ReportPdfRenderer2 do
  alias MyHive.Reports

  def call(html, report_id, toc \\ false, code \\ nil) do
    {:ok, path} = Briefly.create
    File.write!(path, html)
    System.cmd(converted_path(), [
        "--out=/tmp/#{report_id}.pdf",
         "--marginTop", "0.8in",
         "--marginBottom", "1in",
         "--marginLeft", left_margin(code),
         "--marginRight", "0.8in",
         "--format", "A4",
         "--displayHeaderFooter", "true",
         "--headerTemplate", "<span></span>",
         "--footerTemplate", footer_html(report_id),
        "file://"<> path])
    if (toc) do
      {:ok, "/tmp/#{report_id}_toc.pdf"}
    else
      {:ok, "/tmp/#{report_id}.pdf"}
    end
  end

  defp footer_html(report_id) do
    report = Reports.by_id(report_id)
    Phoenix.View.render_to_string(MyHiveWeb.ReportView,
      "#{report.report_template.code}_footer.html",
      conn: %Plug.Conn{},
      report: report
    )
  end

  def converted_path() do
    if env() == :dev do
      "/Users/marcin/Kod/my_hive/assets/node_modules/.bin/chromehtml2pdf"
    else
      "/home/deployer/apps/myhive/current/assets/node_modules/.bin/chromehtml2pdf"
    end
  end

  defp left_margin(code) when code == "lt" do
    "0.8in"
  end

  defp left_margin(code) when code != "lt" do
    "0.4in"
  end

  defp env do
    Application.get_env(:my_hive, :environment)
  end

end
