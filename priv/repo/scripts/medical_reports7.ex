
alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportTemplate,
  ReportSection,
  ReportTemplateSection
}

sections = [
  %{
    name: "Glossary of Terms",
    letter: "GoT",
    is_letter_visible: false
  }
]
Enum.each(sections, fn sec ->
  ReportSection.changeset(%ReportSection{}, sec)
    |> Repo.insert()
end)

report = Reports.find_template_by_code("mr_on_bod") 
  |> Repo.preload(:report_sections)

report
 |> ReportTemplate.changeset(%{has_glossary_of_terms: true})
 |> Repo.update()  

Enum.each(report.report_sections, fn rts -> 
  rts
    |> ReportTemplateSection.changeset(%{is_multiple: true})
    |> Repo.update()
end)

report_sections = [
  %{
    report_template_id: Reports.find_template_by_code("mr_on_bod").id,
    report_section_id: Reports.find_report_section_by_name("Glossary of Terms").id,
    is_taggable: true, 
    order: 0
  },
   %{
    report_template_id: Reports.find_template_by_code("mr_on_bod").id,
    report_section_id: Reports.find_report_section_by_name("Summary").id,
    order: 1,
    is_multiple: true
  },
  %{
    report_template_id: Reports.find_template_by_code("mr_on_bod").id,
    report_section_id: Reports.find_report_section_by_name("Introduction & Document List").id,
    order: 2
  },
  %{
    report_template_id: Reports.find_template_by_code("mr_on_bod").id,
    report_section_id: Reports.find_report_section_by_name("Medical History Summary").id,
    has_timestamp: true,
    order: 3,
    is_multiple: true
  },
  %{
    report_template_id: Reports.find_template_by_code("mr_on_bod").id,
    report_section_id: Reports.find_report_section_by_name("Opinion").id,
    order: 4,
    is_multiple: true
  }
]

Enum.each(report_sections, fn rs ->
  ReportTemplateSection.changeset(%ReportTemplateSection{}, rs)
    |> Repo.insert()
end)
