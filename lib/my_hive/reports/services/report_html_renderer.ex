defmodule MyHive.Reports.ReportHtmlRenderer do

  alias MyHive.{
    Repo, Reports, Saas, CVFields
  }
  import MyHive.Accounts.CVRendererCommon

	def call(report_id) do
    report = Reports.by_id(report_id)
    account = Saas.first_account() |> Repo.preload(:address)
    to_html(report, account)
  end

  defp to_html(report, account) do
    fields = CVFields.all_user_fields(report.user)
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
      instructing_party_address: instructing_party_address(medico_legal_case(report).instructing_party),
      string_cv_fields: filtered_fields(fields, "string", :non_blank),
      text_cv_fields: filtered_fields(fields, "text", :non_blank)
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
