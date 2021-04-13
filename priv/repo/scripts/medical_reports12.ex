alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportSection,
  ReportTemplateSection
}
#delete old
report = Reports.find_template_by_code("mr_on_bod")  |> Repo.preload(:report_sections)

Enum.each(report.report_sections, fn rts -> 
   rts = Repo.preload(rts, :report_section)
  case rts.report_section.letter do 
    "H" -> 
      Repo.delete(rts)
    _ -> nil
  end
end)
#add new one
sections = [
  %{
    name: "Medical History / Chronology",
    letter: "H",
    is_letter_visible: true
  }
]
Enum.each(sections, fn sec ->
  ReportSection.changeset(%ReportSection{}, sec)  |> Repo.insert()
end)

report_sections = [
  %{
    report_template_id: Reports.find_template_by_code("mr_on_bod").id,
    report_section_id: Reports.find_report_section_by_name("Medical History / Chronology").id,
    has_timestamp: true,
    order: 3,
    is_multiple: true
  }
]

Enum.each(report_sections, fn rs ->
  ReportTemplateSection.changeset(%ReportTemplateSection{}, rs) |> Repo.insert()
end)

