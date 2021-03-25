defmodule MyHive.Reports.ReportPdfRenderer2 do 

  def call(html, report_id, toc \\ false, code \\ nil) do
    {:ok, path} = Briefly.create
    File.write!(path, html)
    System.cmd(converted_path(), [
        "--out=/tmp/#{report_id}.pdf",
         "--marginTop", "0.8in",
         "--marginBottom", "0.8in",
         "--marginLeft", left_margin(code),
         "--marginRight", "0.8in",
         "--format", "A4",
         "--displayHeaderFooter", "true",
         "--headerTemplate", "<span></span>",
         "--footerTemplate",  "<div style='margin: 0 auto; font-size: 12px'><div class='pageNumber'></div></div>",
        "file://"<>path])
    if (toc) do
      {:ok, "/tmp/#{report_id}_toc.pdf"}
    else   
      {:ok, "/tmp/#{report_id}.pdf"}
    end
  end

  def converted_path() do
    if env() == :dev do
      "/Users/marcinwalczak/Kod/myhive/assets/node_modules/.bin/chromehtml2pdf"
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