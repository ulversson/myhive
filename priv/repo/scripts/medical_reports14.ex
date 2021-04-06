alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportTemplateSection
}

report = Reports.find_template_by_code("mr_on_bod") 
  |> Repo.preload(:report_sections)

Enum.each(report.report_sections, fn rts -> 
  rts = Repo.preload(rts, :report_section)
  case rts.report_section.letter do 
    "O" -> 
      rts 
        |> ReportTemplateSection.changeset(%{has_subheading: true}) 
        |> Repo.update()
    "S" -> 
        rts 
          |> ReportTemplateSection.changeset(%{has_subheading: true}) 
          |> Repo.update()
    _ -> nil
  end
end)
