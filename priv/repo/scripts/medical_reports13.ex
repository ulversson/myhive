alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportTemplateSection
}

report = Reports.find_template_by_code("mr_on_bod")   |> Repo.preload(:report_sections)

Enum.each(report.report_sections, fn rts -> 
  rts = Repo.preload(rts, :report_section)
  case rts.report_section.letter do 
    "IDL" -> 
        html = '<div>This&nbsp;non-part 35 CPR compliant&nbsp;medical report has been requested by [<span style="background-color: rgb(255, 239, 158);">name of instructing party</span>]&nbsp;in a potential claim pertaining to the clinical care afforded to [<span style="background-color: rgb(255, 239, 158);">name of patient</span>]. In preparing this report, I have not had the benefit of a patient consultation&nbsp;but have had sight of the&nbsp;following documentation:</div><ol><li>&nbsp;</li><li>&nbsp;</li><li>&nbsp;</li><li>&nbsp;</li></ol><div><br></div>'
        rts |> ReportTemplateSection.changeset(%{default_content: List.to_string(html)}) |> Repo.update()
    _ -> nil
  end
end)
