
alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportTemplate,
  ReportSection,
  ReportTemplateSection
}


report_sections = [
  %{
    report_template_id: Reports.find_template_by_code("mr_on_bod").id,
    report_section_id: Reports.find_report_section_by_name("Summary").id
  },
  %{
    report_template_id: Reports.find_template_by_code("mr_on_bod").id,
    report_section_id: Reports.find_report_section_by_name("Introduction & Documents List").id
  },
  %{
    report_template_id: Reports.find_template_by_code("mr_on_bod").id,
    report_section_id: Reports.find_report_section_by_name("Opinion").id
  }
]

Enum.each(report_sections, fn rs ->
  ReportTemplateSection.changeset(%ReportTemplateSection{}, rs)
    |> Repo.insert()
end)
