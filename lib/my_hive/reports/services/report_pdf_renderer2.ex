defmodule MyHive.Reports.ReportPdfRenderer2 do 

  def call(html, report_id) do
    {:ok, path} = Briefly.create
    File.write!(path, html)
    System.cmd("/Users/marcinwalczak/Kod/myhive/assets/node_modules/.bin/chromehtml2pdf", [
        "--out=/tmp/#{report_id}.pdf",
         "--marginTop", "0.8in",
         "--marginBottom", "0.8in",
         "--marginLeft", "0.4in",
         "--marginRight", "0.8in",
        "file://"<>path])
    {:ok, "/tmp/#{report_id}.pdf"}
  end
  
end