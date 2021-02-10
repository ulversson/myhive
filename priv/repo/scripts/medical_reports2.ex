
alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportTemplate,
  ReportSection,
  ReportTemplateSection
}

sections = [
  %{
    name: "Introduction & Document List",
    letter: "IDL",
    is_letter_visible: false
  }
]
Enum.each(sections, fn sec ->
  ReportSection.changeset(%ReportSection{}, sec)
    |> Repo.insert()
end)

report = Reports.find_template_by_code("screening_mr") 
  |> Repo.preload(:report_sections)

Enum.each(report.report_sections, fn rts -> 
  rts
    |> ReportTemplateSection.changeset(%{is_multiple: true})
    |> Repo.update()
end)

report_sections = [
  %{
    report_template_id: Reports.find_template_by_code("screening_mr").id,
    report_section_id: Reports.find_report_section_by_name("Introduction & Document List").id,
    is_multiple: false
  },
]

Enum.each(report_sections, fn rs ->
  ReportTemplateSection.changeset(%ReportTemplateSection{}, rs)
    |> Repo.insert()
end)
