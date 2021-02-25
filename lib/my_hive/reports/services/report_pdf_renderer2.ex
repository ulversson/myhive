defmodule MyHive.Reports.ReportPdfRenderer2 do 

  def call(html, report_id) do
    {:ok, path} = Briefly.create
    File.write!(path, html)
    System.cmd(converted_path(), [
        "--out=/tmp/#{report_id}.pdf",
         "--marginTop", "0.8in",
         "--marginBottom", "0.8in",
         "--marginLeft", "0.4in",
         "--marginRight", "0.8in",
        "file://"<>path])
    {:ok, "/tmp/#{report_id}.pdf"}
  end

  def converted_path() do
    if env() == :dev do
      "/Users/marcinwalczak/Kod/myhive/assets/node_modules/.bin/chromehtml2pdf"
    else
      "/home/deployer/apps/myhive/current/assets/node_modules/.bin/chromehtml2pdf"     
    end 
  end

  defp env do
    Application.get_env(:my_hive, :environment)
  end
  
end