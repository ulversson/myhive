defmodule MyHive.Reports.ReportPdfRenderer do 

  def call(html, report_id) do 
    PdfGenerator.generate(
      html,
      page_size: "A4",
      shell_params: shell_params(report_id)
    )
  end

  defp shell_params(report_id) do
    [
      "-O", "Portrait",
      "-B" ,"10", "-L", "18", 
      "-R", "18", "-T", "18",
      "--print-media-type",
      "--footer-center", "2",
      "--footer-font-name", "Times",
      "--footer-font-size", "11"
    ]
  end

end