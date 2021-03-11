defmodule MyHive.Reports.TocParsers.MrOnBodTocParser do 

  alias MyHive.Reports.ReportPdfRenderer

  def call(report, pdf_path) do
    toc_html = Phoenix.View.render_to_string(MyHiveWeb.ReportView,
      "#{report.report_template.code}_toc.html",
      conn: %Plug.Conn{}
    )
   map = report.report_template.toc_string
    |> get_ary(pdf_path)
    |> toc_map()
   out_html =  Map.keys(map)
      |> Enum.reduce(toc_html, fn key, str ->
        page_val = case key do
          "ABBREVIATED CV" -> "Page: cv"
          "DECLARATION OF RESPONSIBLITIES" -> "Page: d"
          "GLOSSARY OF TERMS" -> "Page: got"
          "SUMMARY" -> "Page: s"
          "INTRODUCTION & DOCUMENT LIST" -> "Page: idl"
          "OPINION ON BREACH OF DUTY" -> "Page: o"
          "MEDICAL HISTORY / CHRONOLOGY" -> "Page: h"
          _ -> ""
        end
      if (page_val != "") do
        String.replace(str, page_val, "Page: #{map[key]}")
      else
       str 
      end
    end)
    toc_pdf_path = ReportPdfRenderer.call(out_html, report.id) 
      |> elem(1) 
    swap_toc_page(report, pdf_path, toc_pdf_path)
  end

  def get_ary(toc_string, pdf_path) do
     toc_string 
      |> String.split("|") 
      |> Enum.map(&String.trim/1) 
      |> Enum.map(fn term -> 
        res = System.cmd("pdfgrep", ["-Rin", term,  pdf_path]) 
        {l, 0} = res
        String.split(l, "\n")
      end) 
      |> List.flatten 
      |> Enum.filter(fn str -> String.starts_with?(str, "2:") == false end) 
      |> Enum.map(fn it -> String.split(it, ":") end) 
      |> Enum.filter(fn i -> length(i) > 1 end) 
  end

  def toc_map(toc_arry) do 
    toc_arry
      |> Enum.map(fn a -> {(List.last(a) |> String.trim), List.first(a)} end) 
      |> Map.new 
      |> Enum.filter(fn {k,v} -> String.length(k) > 1 end)
      |> Map.new
  end

  def swap_toc_page(report, pdf_path, toc_pdf_path) do 
    final_pdf = "/tmp/#{report.id}_final.pdf"
    res = System.cmd("/usr/bin/pdftk", [
      "A=#{pdf_path}",
      "B=#{toc_pdf_path}",
      "cat",
      "A1",
      "B1",
      "A3-end",
      "output",
      final_pdf
    ])
    final_pdf
  end
#pdftk  A=/Users/marcinwalczak/Downloads/tog/1.pdf B=/Users/marcinwalczak/Downloads/tog/rep.pdf cat A1 B1 A3-end output outing.pdf 
end