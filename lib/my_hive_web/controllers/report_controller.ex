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
      instructing_party_address: instructing_party_address(medico_legal_case(report).instructing_party),
      instructing_party_centered_address: instructing_party_centered_address(medico_legal_case(report).instructing_party),
      patient_address: patient_address(report.medico_legal_case),
      centered_address: centered_address(account)
    })
  end

  def footer(conn, %{"id" => id}) do 
  	report = Reports.by_id(id)
    render(conn, "#{report.report_template.code}_footer.html",
      report: report
    )
  end

  defp address(account) do 
    account.address.address
      |> map_address_line()
      |> Enum.map(fn line -> "<span style='float:right'>#{line}</span>"  end) 
      |> Enum.join("<br/>")
  end


  defp centered_address(account) do 
    account.address.address
      |> map_address_line()
      |> Enum.map(fn line -> "<tr><td style='text-align: center; font-weight: normal'>#{line}</td></tr>"  end) 
  end

  defp medico_legal_case(report) do 
    Repo.preload(report.medico_legal_case, [:instructing_party, {:patient, :addresses}])
  end

  defp instructing_party_address(ip) do 
     ip = Repo.preload(ip, :addresses)   
     address = List.first(ip.addresses)
     address.address
      |> map_address_line()
      |> Enum.map(fn line -> "<tr><td>#{line}</td></tr>"  end) 
  end

   defp patient_address(mlc) do
     patient = mlc.patient 
     patient = Repo.preload(patient, :addresses)   
     address = List.first(patient.addresses)
     address.address
      |> map_address_line()
      |> Enum.map(fn line -> "<tr><td style='text-align: center'>#{line}</td></tr>"  end) 
  end

    defp instructing_party_centered_address(ip) do 
     ip = Repo.preload(ip, :addresses)   
     address = List.first(ip.addresses)
      address.address
      |> map_address_line()
      |> Enum.map(fn line -> "<tr><td style='text-align: center'>#{line}</td></tr>"  end) 
    end


  defp map_address_line(address_text) do 
    if (String.contains?(address_text, ",")) do 
      String.split(address_text, ",")
        |> Enum.map(&String.trim/1)
    else
      String.split(address_text, "\n")
        |> Enum.map(&String.trim/1)
    end
  end 
end
