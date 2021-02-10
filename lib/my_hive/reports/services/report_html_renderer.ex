defmodule MyHive.Reports.ReportHtmlRenderer do 

  alias MyHive.{
    Repo, Reports, Saas
  }

	def call(report_id) do 
    report = Reports.by_id(report_id)
    account = Saas.first_account() |> Repo.preload(:address)
    to_html(report, account)
  end

  defp to_html(report, account) do
    Phoenix.View.render_to_string(MyHiveWeb.ReportView,
      "#{report.report_template.code}.html",
      conn: %Plug.Conn{},
      report: report,
      account: account,
      address: address(account),
      centered_address: centered_address(account),
      medico_legal_case: medico_legal_case(report),
      instructing_party_centered_address: instructing_party_centered_address(medico_legal_case(report).instructing_party),
      patient_address: patient_address(report.medico_legal_case),
      instructing_party_address: instructing_party_address(medico_legal_case(report).instructing_party)
    )
  end

  defp centered_address(account) do 
    String.split(account.address.address , "\n")
      |> Enum.map(fn line -> "<tr><td style='text-align: center; font-weight: normal'>#{line}</td></tr>"  end) 
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

  defp patient_address(mlc) do
     patient = mlc.patient 
     patient = Repo.preload(patient, :addresses)   
     address = List.first(patient.addresses)
     String.split(address.address, ",")
      |> Enum.map(fn line -> "<tr><td style='text-align: center'>#{line}</td></tr>"  end) 
  end

  defp instructing_party_centered_address(ip) do 
     ip = Repo.preload(ip, :addresses)   
     address = List.first(ip.addresses)
     String.split(address.address, ",")
      |> Enum.map(fn line -> "<tr><td style='text-align: center'>#{line}</td></tr>"  end) 
  end
end