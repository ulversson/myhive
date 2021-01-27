defmodule MyHiveWeb.ReportController do
  use MyHiveWeb, :controller
  plug :put_layout, {MyHiveWeb.LayoutView, :pdfexport}
  alias MyHive.{Saas, Reports, Repo}

  def show(conn, %{"id" => id}) do
    report = Reports.by_id(id)
    account = Saas.first_account() 
    	|> Repo.preload(:address)
    render(conn, "#{report.report_template.code}.html", %{
      report: report,
      account: account,
      address: address(account),
      medico_legal_case: medico_legal_case(report),
      instructing_party_address: instructing_party_address(medico_legal_case(report).instructing_party)
    })
  end

  def footer(conn, %{"id" => id}) do 
  	report = Reports.by_id(id)
    render(conn, "#{report.report_template.code}_footer.html",
      report: report
    )
  end

  defp address(account) do 
    String.split(account.address.address , "\n")
      |> Enum.map(fn line -> "<span style='float:right'>#{line}</span>"  end) 
      |> Enum.join("<br/>")
  end

  defp medico_legal_case(report) do 
    Repo.preload(report.medico_legal_case, [:instructing_party, :patient])
  end

  defp instructing_party_address(ip) do 
     ip = Repo.preload(ip, :addresses)   
     address = List.first(ip.addresses)
     String.split(address.address, ",")
      |> Enum.map(fn line -> "<tr><td>#{line}</td></tr>"  end) 
  end
end
