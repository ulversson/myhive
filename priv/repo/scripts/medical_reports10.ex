
alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportSection,
  ReportTemplateSection
}

sections = [
  %{
    name: "Literature",
    letter: "L",
    is_letter_visible: false
  }
]
Enum.each(sections, fn sec ->
  ReportSection.changeset(%ReportSection{}, sec)  |> Repo.insert()
end)

report = Reports.find_template_by_code("mr_on_bod") |> Repo.preload(:report_sections)

report_sections = [
  %{
    report_template_id: Reports.find_template_by_code("mr_on_bod").id,
    report_section_id: Reports.find_report_section_by_name("Literature").id,
    is_taggable: false, 
    is_multiple: false,
    has_timestamp: false,
    order: 6
  }
]

Enum.each(report_sections, fn rs ->
  ReportTemplateSection.changeset(%ReportTemplateSection{}, rs) |> Repo.insert()
end)
