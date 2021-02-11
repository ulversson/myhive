


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
        |> ReportTemplateSection.changeset(%{order: 0})
        |> Repo.update()
    "MHS" -> 
         rts
        |> ReportTemplateSection.changeset(%{order: 1})
        |> Repo.update()
    "O" -> 
         rts
        |> ReportTemplateSection.changeset(%{order: 2})
        |> Repo.update()
  end


end)
