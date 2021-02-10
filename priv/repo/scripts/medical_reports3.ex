


alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportTemplateSection
}

report = Reports.find_template_by_code("screening_mr") 
  |> Repo.preload(:report_sections)

Enum.each(report.report_sections, fn rts -> 
  rts = Repo.preload(rts, :report_section)
  case rts.report_section.letter do 
    "IDL" -> 
        rts
        |> ReportTemplateSection.changeset(%{has_timestamp: false})
        |> Repo.update()
    "MHS" -> 
         rts
        |> ReportTemplateSection.changeset(%{has_timestamp: true})
        |> Repo.update()
    "O" -> 
         rts
        |> ReportTemplateSection.changeset(%{has_timestamp: false})
        |> Repo.update()
  end


end)
