
alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportTemplate, 
  ReportTemplateSection
}
toc = "ABBREVIATED CV|Glossary of terms|Summary|Introduction & Document List|Summary|Medical History|Opinion on Breach of Duty|DECLARATION OF RESPONSIBLITIES"

rt = Reports.find_template_by_code("mr_on_bod")

rt |> ReportTemplate.changeset(%{toc_string: toc}) |> Repo.update()

report = Reports.find_template_by_code("screening_mr")  |> Repo.preload(:report_sections)

Enum.each(report.report_sections, fn rts -> 
   rts = Repo.preload(rts, :report_section)
  case rts.report_section.letter do 
    "H" -> 
      ReportTemplateSection.changeset(rts, %{is_optional: true})
        |> Repo.update()
    _ -> nil
  end
end)

